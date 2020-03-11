import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class ParserCSVXML {

	static String path = "C:\\Users\\Matt\\Desktop\\FACM2Data\\BDD\\FINALCSV\\SALAIREFINAL.txt";
	static String outputFile = "C:\\\\Users\\\\Matt\\\\Desktop\\\\FACM2Data\\\\BDD\\\\FINALCSV\\XMLres.xml";
	
	public static void main(String[] args) {
		BufferedReader reader;
		try {
			reader = new BufferedReader(new FileReader(path));
			String line = reader.readLine();
			String[] headers = line.split(",");
			try
			{
				Files.write(Paths.get(outputFile), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<dataset>\n".getBytes(), StandardOpenOption.APPEND);
			}
			catch(IOException e) {}
			line = reader.readLine();
			while(line != null)
			{
 			    String[] data = line.split(",");
				if(data.length > 1)
				{
					String section = "    <ligne id=\"" + data[0].replaceAll("\"", "") + "\">\n        <date annee=\""+ data[1].replaceAll("\"", "") +
							"\"></date>\n        <localisation>\n            <codePostal>"
							+ data[2].replaceAll("\"", "") + "</codePostal>\n            <ville>"+data[3].replaceAll("\"", "")
							+"</ville>\n            <departement>"+data[7].replaceAll("\"", "")+"</departement>\n            <region>"+data[8].replaceAll("\"", "")+"</region>\n            <codeDep>"
							+ data[9].replaceAll("\"", "")+"</codeDep>\n        </localisation>\n        <categorie nom=\""
							+data[5].replaceAll("\"", "")+"\"></categorie>\n        <genre nom=\""+data[4].replaceAll("\"", "")+"\"></genre>\n        <salaire>"+data[6].replaceAll("\"", "")+"</salaire>\n    </ligne>\n"; 

					try
					{
						Files.write(Paths.get(outputFile), section.getBytes(), StandardOpenOption.APPEND);
					}
					catch(IOException e) {}
				}
				
				
				line = reader.readLine();
			}
			try
			{
				Files.write(Paths.get(outputFile), "</dataset>".getBytes(), StandardOpenOption.APPEND);
			}
			catch(IOException e) {}
		}
		catch(Exception e) {System.out.println("ERROR");}

	}

}
