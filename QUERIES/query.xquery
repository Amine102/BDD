1- /CV/EDUCATION/ENTRY[1]/DIPLOME

2- for $i in /CV/EXPERIENCE/ENTRY
	return <fonction> {$i/DATES} {$i/FONCTION} {$i/SECTEUR} </fonction>

3- 	for $j in /CV/EDUCATION/ENTRY where $j/ETABLISSEMENT="Université de Nantes" 
		return {$j/NOM} a fait des études à Nantes

4-  for $k in /CV/EDUCATION/COMPETENCESPERSONNELLES/LANGUEMATERNELLE where count($k)>=1
		return{$k/NOM} parle {count($k)} langues etrangeres: {$k/LANGUE}
			
6- <html> 
		<head></head>
			<body>
				<table border="1">
				    <thead>
				      <tr>
				          <th>Nom</th> 
				          <th>Nationalite</th>
				          <th>Sexe</th>
				          <th>Naissance</th>
				      </tr>
				    </thead>
				    <tbody>{
				       for $term at $count in doc("cv.xml")/CORDONNEE
				            let $nom := $term/NOM/text()
				            order by upper-case($nom)
				       return
				         <tr> 
				           <td>{$term/NOM/text()}</td>
				           <td>{$term/NATIONALITE/text()}</td>
				           <td>{$term/SEXE/text()}</td>
				           <td>{$term/NAISSANCE/text()}</td>
				         </tr>
				       }</tbody>
				     </table>
			</body>
	</html>

7-  <html> 
		<head></head>
			<body>
				<table border="1">
				    <thead>
				      <tr>
				          <th>Nom</th> 
				          <th>Nationalite</th>
				          <th>Sexe</th>
				          <th>Naissance</th>
				      </tr>
				    </thead>
				    <tbody>{
				    	let $doc1 := doc("cv.xml")
				    	let $doc2 := doc("cv2.xml")
				       for $term at $count in $doc1/CORDONNEE
				            let $nom := $term/NOM/text()
				            order by upper-case($nom)
				       return
				         <tr> 
				           <td>{$term/NOM/text()}</td>
				           <td>{$term/NATIONALITE/text()}</td>
				           <td>{$term/SEXE/text()}</td>
				           <td>{$term/NAISSANCE/text()}</td>
				         </tr>
				       }</tbody>
				     </table>
			</body>
	</html>



