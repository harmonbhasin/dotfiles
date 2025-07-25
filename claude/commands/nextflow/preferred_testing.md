# Your task

Implement test(s) for #$ARGUMENTS following our coding standards:

## Core Principle
**Test transformations, not exact strings.** Focus on validating that data flows correctly through the pipeline and that operations produce the expected logical results.

## Key Guidelines

### General
- Use `process.errorReport.contains` not `process.stderr.contains`
- When testing a file with only the header, '.csv' won't work, so use `.text.split("\n")`, then you can further check the number of columns by using `.text.split('\t')`
- Every process should have a resource, and container label:
  - Make sure your container label exists in `configs/resources.config`
  - Make sure your resource label exists in `configs/containers.config`
- Set `set -eou pipefail` in processes such that errors propagate
- Every test should point to a config that is located in `tests/config/`
- Put non-channel inputs (like string values, numbers, or configuration maps) into params, but keep channel inputs (like tuples with sample IDs and file paths) inline in the process block.
- Do not write obvious comments, comments should only be written for non-obvious code
- Avoid hardcoded assertions in tests - derive expected values from the input data or test parameters instead.
- Every test needs one required tag + optional descriptive tags
  - Required: expect_success OR expect_failure
  - Optional: empty_input, header_only, single_end, etc.
  - Example: tags: ["expect_success", "empty_input"] (but put them on separate lines without the brackets)
- Remove unnecessary newlines within functions


### 1. Use nf-test Built-in Helpers
- Use `path().csv(sep: "\t", decompress: true)` for structured TSV/CSV data
- Use `path().fastq` for FASTQ files  
- Use `sam()` for SAM files
- These helpers provide structured access to data rather than raw string manipulation

### 2. Test Data Integrity Through Transformations
Instead of asserting exact string matches, validate:
- **Row counts**: Do input and output row counts match expected transformations?
- **Column operations**: Are columns properly selected, renamed, or transformed?
- **Join integrity**: Do all output records have corresponding input records?
- **Filter accuracy**: Are only expected records retained after filtering?

### 3. Structure Your Tests

#### Basic Structure Validation
```groovy
// Validate file exists and has content
assert outputData.columnCount > 0
assert outputData.rowCount > 0

// Validate expected columns
assert "expected_col" in outputData.columns.keySet()
assert outputData.columnCount == expectedCount
```

#### Data Transformation Validation
```groovy
// Compare input vs output using structured data
def inputIds = inputData.columns["id_column"].toSet()
def outputIds = outputData.columns["id_column"].toSet()

// Validate logical relationships
assert outputIds.isSubsetOf(inputIds) // for filtering
assert outputIds == expectedIds // for specific transformations
```

#### Value Preservation
```groovy
// Validate that data values are preserved through transformations
// Note: CSV data in nf-test uses column-based access, not row iteration
for (int i = 0; i < outputData.rowCount; i++) {
    def key = outputData.columns["key_column"][i]
    
    // Find corresponding input row by index
    def inputIndex = inputData.columns["key_column"].findIndexOf { it == key }
    
    // Check specific value preservation
    assert outputData.columns["output_col"][i] == inputData.columns["input_col"][inputIndex]
}
```

#### Filtering Based on Column Values
```groovy
// Example: Filter rows where classification == "primary"
def filteredIds = []
for (int i = 0; i < data.rowCount; i++) {
    if (data.columns["classification"][i] == "primary") {
        filteredIds.add(data.columns["id"][i])
    }
}
def filteredIdSet = filteredIds.toSet()
```

### 4. Test Multiple Inputs When Available
When your workflow emits test inputs (like `test_lca`, `test_bowtie`), use them to validate:
- Join operations worked correctly
- Filtering preserved the right records
- Data values were properly transformed

### 5. Avoid These Anti-patterns
- ❌ Asserting exact string matches against output content
- ❌ Hardcoding expected output values
- ❌ Testing only that the process succeeded without validating logic
- ❌ Manual string parsing when structured helpers are available

### 6. Example Pattern
```groovy
then {
    assert workflow.success
    
    // Parse structured data
    def inputData = path(workflow.out.test_input[0][1]).csv(sep: "\t", decompress: true)
    def outputData = path(workflow.out.output[0][1]).csv(sep: "\t", decompress: true)
    
    // Validate structure
    assert outputData.columnCount > 0
    assert "key_column" in outputData.columns.keySet()
    
    // Validate transformations
    def inputIds = inputData.columns["id"].toSet()
    def outputIds = outputData.columns["id"].toSet()
    assert outputIds.isSubsetOf(inputIds)
    
    // Validate data integrity with proper column access
    for (int i = 0; i < outputData.rowCount; i++) {
        def id = outputData.columns["id"][i]
        def inputIndex = inputData.columns["id"].findIndexOf { it == id }
        
        // Validate transformation logic
        def expectedValue = expectedTransformation(inputData.columns["source_col"][inputIndex])
        assert outputData.columns["transformed_col"][i] == expectedValue
    }
}
```

### 7. Important CSV Access Patterns
- **Access columns**: Use `.columns["column_name"]` to get a list of all values in that column
- **Access by index**: Use `.columns["column_name"][index]` to get a specific value
- **Row count**: Use `.rowCount` property
- **Column names**: Use `.columns.keySet()` or `.columnNames`
- **Find index**: Use `.columns["column"].findIndexOf { condition }` to locate values
- **No direct row iteration**: Cannot use `.each` on CSV data directly; use index-based loops

### 8. Understanding Types in nf-test

Type mismatches are a common source of test failures. Always verify types when tests fail unexpectedly.

#### Nextflow Channel Outputs
```groovy
// Nextflow outputs are channels containing values
// For single-value emissions:
def cols = workflow.out.test_columns[0]  // Extract the value from the channel

// For tuple emissions (e.g., [sample_id, file]):
def outputTuple = workflow.out.output[0]  // Get the tuple from channel
def sampleId = outputTuple[0]            // First element of tuple
def file = outputTuple[1]                // Second element of tuple

// Or access directly:
def file = workflow.out.output[0][1]     // Channel index [0], then tuple index [1]
```

#### Groovy String Types
```groovy
// String interpolation creates GString, not String
def prefixedCol = "${prefix}${column}"  // GString type
def regularStr = "prefix_column"        // String type

// These can fail equality checks even with identical values!
// Solution: Convert GString to String explicitly
def prefixedCol = "${prefix}${column}".toString()
```

#### Debugging Type Issues
When assertions fail unexpectedly, check types:
```groovy
println "Variable type: ${myVar.getClass()}"
println "Variable value: '${myVar}'"

// For collections, check element types too
println "First element type: ${myCollection.first().getClass()}"
```

#### Common Type Patterns in nf-test
1. **Single value outputs**: Index with `[0]` to extract from channel
2. **Tuple outputs**: Use `[0]` for channel, then `[index]` for tuple element
3. **String comparisons**: Use `.toString()` after string interpolation when comparing with Map keys
4. **CSV data**: Column access returns lists, not individual values

### 9. Setup Function Best Practices

The `setup` block is crucial for preparing test data by running prerequisite processes. Here are key patterns:

#### Chain Dependent Processes
```groovy
setup {
    // First process - load initial data
    run("LOAD_SAMPLESHEET") {
        script "subworkflows/local/loadSampleSheet/main.nf"
        process {
            """
            input[0] = "${projectDir}/test-data/samplesheet.csv"
            input[1] = "illumina"
            input[2] = false
            """
        }
    }
    
    // Second process - use output from first
    run("INTERLEAVE_FASTQ") {
        script "modules/local/interleaveFastq/main.nf"
        process {
            '''
            input[0] = LOAD_SAMPLESHEET.out.samplesheet
            '''
        }
    }
    
    // Continue chaining...
    run("BOWTIE2") {
        script "modules/local/bowtie2/main.nf"
        process {
            '''
            input[0] = INTERLEAVE_FASTQ.out.output 
            input[1] = "${params.ref_dir}/results/bt2-virus-index"
            // ... more inputs
            '''
        }
    }
}
```

#### Key Setup Patterns

1. **Verify process exists**: Always ensure the process name in `run()` matches an actual process
   ```groovy
   run("BOWTIE2") {  // ✓ Make sure BOWTIE2 process actually exists
       script "modules/local/bowtie2/main.nf"
       // ...
   }
   ```

2. **Match variable names to the process being tested**: When setting up data for a process, use variable names that match what you're testing
   ```groovy
   // If testing a process that uses bowtie2 output:
   run("BOWTIE2") {  // Use same process name
       script "modules/local/bowtie2/main.nf"
       process {
           '''
           // Check the actual process definition for required inputs!
           input[0] = INTERLEAVE_FASTQ.out.output    // reads channel
           input[1] = "${params.ref_dir}/results/bt2-virus-index"  // index
           input[2] = "--local --very-sensitive-local"  // options
           input[3] = "virus"  // label
           input[4] = true     // save_sam
           input[5] = false    // save_unmapped
           input[6] = true     // paired_end
           '''
       }
   }
   ```

3. **Document input parameters**: Always check and comment what each input represents
   ```groovy
   run("PROCESS_VIRAL_BOWTIE2_SAM_LCA") {
       script "modules/local/processViralBowtie2SamLca/main.nf"
       process {
           '''
           input[0] = SORT_FILE.out.output  // sorted SAM file
           input[1] = "${params.ref_dir}/results/virus-genome-metadata-gid.tsv.gz"  // metadata
           input[2] = "${params.ref_dir}/results/total-virus-db-annotated.tsv.gz"   // virus db
           input[3] = true  // paired_end flag
           '''
       }
   }
   ```

4. **Use aliases for multiple runs**: When running the same process multiple times with different inputs
   ```groovy
   run("LOAD_SAMPLESHEET", alias: "LOAD_SAMPLESHEET_SINGLE") {
       // Different configuration
   }
   ```

5. **Reference outputs properly**: Access outputs from setup processes using `.out.<channel_name>`
   ```groovy
   input[0] = PREVIOUS_PROCESS.out.output
   ```

6. **Mix string types appropriately**:
   - Use `"""` for inputs that need interpolation (e.g., `${projectDir}`)
   - Use `'''` for inputs referencing previous process outputs

7. **Build complex test scenarios**: Chain multiple processes to create realistic test data that exercises your workflow properly

8. **Prepare all required inputs**: Ensure all channels your workflow needs are prepared in setup, including reference files, indices, and configuration data

## Benefits of This Approach
1. **Robust**: Tests validate logical correctness, not brittle string matches
2. **Maintainable**: Changes to formatting don't break tests
3. **Readable**: Clear intent about what transformations are being validated
4. **Comprehensive**: Tests both structure and data integrity
5. **Reusable**: Patterns can be applied across different modules/workflows
