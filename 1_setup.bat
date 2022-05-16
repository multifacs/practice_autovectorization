if exist .\llvm-13.0.0.7z (
    echo Skipping file, already downloaded
) else (
    powershell -Command "Invoke-WebRequest https://github.com/vovkos/llvm-package-windows/releases/download/llvm-master/llvm-13.0.0-windows-amd64-msvc15-libcmt.7z -OutFile llvm-13.0.0.7z"
)

if exist .\clang-13.0.0.7z (
    echo Skipping file, already downloaded
) else (
    powershell -Command "Invoke-WebRequest https://github.com/vovkos/llvm-package-windows/releases/download/clang-master/clang-13.0.0-windows-amd64-msvc15-libcmt.7z -OutFile clang-13.0.0.7z"
)

if exist .\llvm (
    echo Skipping extraction
) else (

	if exist .\llvm-13.0.0-windows-amd64-msvc15-libcmt (
		echo Skipping extraction
	) else (
		".\7z.exe" x .\llvm-13.0.0.7z
	)

	if exist .\clang-13.0.0-windows-amd64-msvc15-libcmt (
		echo Skipping extraction
	) else (
		".\7z.exe" x .\clang-13.0.0.7z
	)

    robocopy .\llvm-13.0.0-windows-amd64-msvc15-libcmt\ .\llvm /E /MOVE
	robocopy .\clang-13.0.0-windows-amd64-msvc15-libcmt\ .\llvm /E /MOVE
)

git clone https://github.com/ArtemSkrebkov/autovectorization-practise