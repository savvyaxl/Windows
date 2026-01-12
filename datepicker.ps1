Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = "Select a Date"
$form.Size = New-Object Drawing.Size(250,150)
$form.StartPosition = "CenterScreen"

# Create the DateTimePicker control
$datePicker = New-Object Windows.Forms.DateTimePicker
$datePicker.Location = New-Object Drawing.Point(20,20)
$datePicker.Width = 200

# Create the OK button
$okButton = New-Object Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object Drawing.Point(40,60)
$okButton.Add_Click({
    $form.Tag = $datePicker.Value
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
})

# Create the Cancel button
$cancelButton = New-Object Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object Drawing.Point(120,60)
$cancelButton.Add_Click({
    $form.Tag = $null
    $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Close()
})

# Add controls to the form
$form.Controls.Add($datePicker)
$form.Controls.Add($okButton)
$form.Controls.Add($cancelButton)

# Show the form
$result = $form.ShowDialog()

# Handle output
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $form.Tag.ToString("yyyy-MM-dd")
} else {
    "User cancelled"
}
