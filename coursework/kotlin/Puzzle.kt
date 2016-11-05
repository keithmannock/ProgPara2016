import java.io.File
import javax.swing.JFileChooser

// Using JFileChooser and nullable type

fun main(args: Array<String>) {
    val file = chooseFile()
    println(file ?: "No file selected")

}

fun chooseFile(): File? {
    val chooser = JFileChooser()
    val theFileResult = chooser.showOpenDialog(null)
    chooser.setVisible(true)
    when (theFileResult) {
        JFileChooser.APPROVE_OPTION -> return chooser.getSelectedFile()
        JFileChooser.CANCEL_OPTION -> println("Done choosing files.")
        else -> println("Error: Unable to open file.")
    }
    return null
}
