# Define the path to your CSV file
$csvPath = "result_file.csv"

# Import the CSV file
$data = Import-Csv -Path $csvPath

# Initialize counters
$correctCount = 0
$wrongCount = 0

# Loop through each row in the data
foreach ($row in $data) {
    # Check the column that contains the "Correct" or "Wrong" values
    if ($row.snf_validator -eq "Correct") {
        $correctCount++
    } elseif ($row.snf_validator -eq "Wrong") {
        $wrongCount++
    }
}

# Calculate total and percentages
$totalCount = $correctCount + $wrongCount
$correctPercentage = if ($totalCount -gt 0) { ($correctCount / $totalCount) * 100 } else { 0 }
$wrongPercentage = if ($totalCount -gt 0) { ($wrongCount / $totalCount) * 100 } else { 0 }

# Output the results
Write-Output " "
Write-Output "Correct: $correctCount"
Write-Output "Wrong: $wrongCount"
Write-Output " "
Write-Output "Correct Percentage: $([math]::Round($correctPercentage, 2))%"
Write-Output "Wrong Percentage: $([math]::Round($wrongPercentage, 2))%"
Write-Output " "