#!/usr/bin/env zsh

# Test helper functions
setup() {
    # Create test directory structure
    mkdir -p test_dir/subdir
    echo "test1" >test_dir/file1.txt
    echo "test2" >test_dir/file2.js
    echo "test3" >test_dir/subdir/file3.ts
    echo "test4" >test_dir/subdir/file4.md
    echo "test5" >test_dir/.env.example
    echo "test6" >test_dir/subdir/.env.example

    # Create .gitignore
    echo "*.js" >test_dir/.gitignore
}

teardown() {
    # Clean up test directory
    rm -rf test_dir
}

# Test cases
test_basic_usage() {
    local output=$(fcat test_dir/file1.txt)
    assert_contains "$output" "File: test_dir/file1.txt"
    assert_contains "$output" "test1"
}

test_recursive_directory() {
    local output=$(fcat test_dir)
    assert_contains "$output" "File: test_dir/file1.txt"
    assert_contains "$output" "File: test_dir/subdir/file3.ts"
    assert_contains "$output" "File: test_dir/subdir/file4.md"
}

test_ignore_gitignore() {
    local output=$(fcat test_dir)
    assert_not_contains "$output" "file2.js"

    output=$(fcat -i test_dir)
    assert_contains "$output" "file2.js"
}

test_name_pattern() {
    local output=$(fcat -n '*.ts' test_dir)
    assert_contains "$output" "file3.ts"
    assert_not_contains "$output" "file1.txt"
    assert_not_contains "$output" "file2.js"
}

test_dotfile_pattern() {
    local output=$(fcat -n '.env.example' test_dir)
    assert_contains "$output" "File: test_dir/.env.example"
    assert_contains "$output" "File: test_dir/subdir/.env.example"
    assert_contains "$output" "test5"
    assert_contains "$output" "test6"
}

test_output_file() {
    local output_file="test_output.txt"
    fcat -o "$output_file" test_dir/file1.txt
    assert_file_exists "$output_file"
    assert_contains "$(cat $output_file)" "File: test_dir/file1.txt"
    rm "$output_file"
}

test_clipboard() {
    if command -v pbcopy >/dev/null 2>&1; then
        fcat -c test_dir/file1.txt
        local clipboard_content=$(pbpaste)
        assert_contains "$clipboard_content" "File: test_dir/file1.txt"
    fi
}

# Helper functions
assert_contains() {
    if [[ "$1" != *"$2"* ]]; then
        echo "Assertion failed: '$1' does not contain '$2'"
        return 1
    fi
}

assert_not_contains() {
    if [[ "$1" == *"$2"* ]]; then
        echo "Assertion failed: '$1' contains '$2'"
        return 1
    fi
}

assert_file_exists() {
    if [[ ! -f "$1" ]]; then
        echo "Assertion failed: File '$1' does not exist"
        return 1
    fi
}

# Run tests
main() {
    local tests=(
        test_basic_usage
        test_recursive_directory
        test_ignore_gitignore
        test_name_pattern
        test_dotfile_pattern
        test_output_file
        test_clipboard
    )

    setup

    local failed=0
    for test in "${tests[@]}"; do
        echo "Running $test..."
        if $test; then
            echo "✓ $test passed"
        else
            echo "✗ $test failed"
            ((failed++))
        fi
    done

    teardown

    if [[ $failed -eq 0 ]]; then
        echo "All tests passed!"
        return 0
    else
        echo "$failed tests failed"
        return 1
    fi
}

# Run the tests
if ! (return 0 2>/dev/null); then
    main
fi
