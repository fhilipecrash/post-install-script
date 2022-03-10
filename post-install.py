# Post install configuration script

import sys

print("Post install script by Fhilipe")
print("Would you like to perform the post install configuration? [S/n]\n")

if sys.platform.startswith('linux'):
  print("OS: Arch Linux")
elif sys.platform.startswith('darwin'):
  print("OS: Mac OS")
elif sys.platform.startswith('win32'):
  print("OS: Windows")

