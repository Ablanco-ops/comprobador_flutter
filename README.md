# Punteador de Archivos

La finalidad de este programa es comparar las entradas de datos de dos archivos excel
para comprobar si tienen los mismos valores en ambos archivos.

## Uso

La aplicación se puede configurar desde el menú de configuración o directamente 
desde los archivos 'modelos.json' y 'archivos.json' que se encuentran en la carpeta 
raiz de la aplicación.

Cada modelo establece donde buscar en la hoja excel el identificador de la entrada,un código
adicional opcional, nombre de la hoja, cantidad a comparar, fecha y contenido de una o mas celdas 
para comprobar la validez de la hoja. Los archivos agrupan varios modelos.

Al seleccionar un archivo en la app busca si se corresponde con alguno los archivos configurados, 
una vez introducidos dos archivosse cruzan los datos para comprobar la correspondencia y el resultado 
se puede filtrar y exportar en un xlsx.

## Construido con 

Flutter 2.10.3
