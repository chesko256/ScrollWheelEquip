import os
import shutil
import subprocess

print " "
print "======================================"
print "| Scroll Wheel Equip Release Builder |"
print "|                           _   _    |"
print "|                          ( \_/ )   |"
print "|             _   _       __) _ (__  |"
print "|     _   _  ( \_/ )  _  (__ (_) __) |"
print "|    ( \_/ )__) _ (__( \_/ )) _ (    |"
print "|   __) _ ((__ (_) __)) _ ((_/ \_)   |"
print "|  (__ (_) __)) _ ((__ (_) __)       |"
print "|     ) _ (  (_/ \_)  ) _ (          |"
print "|    (_/ \_)         (_/ \_)         |"
print "======================================"
print " "
user_input = raw_input("Enter the release version: ")

os.chdir("..\\")

# Build the temp directory
print "Creating temp directories..."
tempdir = ".\\tmp\\Data\\"
if os.path.isdir(tempdir):
    print "Removing old temp directory..."
    shutil.rmtree(".\\tmp")

os.makedirs('./tmp/readmes')
os.makedirs('./tmp/Interface/Translations')
os.makedirs('./tmp/Interface/ScrollWheelEquip')
os.makedirs('./tmp/Scripts/Source')

# Copy the project files
print "Copying project files..."
with open("./ScrollWheelEquip/FrostfallArchiveManifest.txt") as manifest:
    lines = manifest.readlines()
    for line in lines:
        shutil.copy(".\\ScrollWheelEquip\\" + line.rstrip('\n'), tempdir + line.rstrip('\n'))

print "Copying existing translation files..."
shutil.copy(".\\ScrollWheelEquip\\Interface\\Translations\\ScrollWheelEquip_ENGLISH.txt", tempdir + "Interface\\Translations\\ScrollWheelEquip_ENGLISH.txt")

# Build the directories
dirname = "./Scroll Wheel Equip " + user_input + " Release"
if not os.path.isdir(dirname):
    print "Creating new build..."
    os.mkdir(dirname)
else:
    print "Removing old build of same version..."
    shutil.rmtree(dirname)
    os.mkdir(dirname)

os.makedirs(dirname + "/readmes")
os.makedirs(dirname + "/Interface/Translations")

# Generate BSA archive
print "Generating BSA archive..."
shutil.copy('./ScrollWheelEquip/Archive.exe', './tmp/Archive.exe')
shutil.copy('./ScrollWheelEquip/ScrollWheelEquipArchiveBuilder.txt', './tmp/ScrollWheelEquipArchiveBuilder.txt')
shutil.copy('./ScrollWheelEquip/ScrollWheelEquipArchiveManifest.txt', './tmp/ScrollWheelEquipArchiveManifest.txt')
# Append the translation file entries to the temporary manifest.
with open('./tmp/ScrollWheelEquipArchiveManifest.txt', 'a') as manifest:
    manifest.write('Interface\\Translations\\ScrollWheelEquip_ENGLISH.txt\r\n')
os.chdir("./tmp")
subprocess.call(['./Archive.exe', './ScrollWheelEquipArchiveBuilder.txt'])
os.chdir("..\\")

# Copy files
shutil.copyfile("./ScrollWheelEquip/ScrollWheelEquip.esp", dirname + "/ScrollWheelEquip.esp")
shutil.copyfile("./tmp/ScrollWheelEquip.bsa", dirname + "/ScrollWheelEquip.bsa")
shutil.copyfile("./ScrollWheelEquip/readmes/ScrollWheelEquip_readme.txt", dirname + "/readmes/ScrollWheelEquip_readme.txt")
shutil.copyfile("./ScrollWheelEquip/readmes/ScrollWheelEquip_license.txt", dirname + "/readmes/ScrollWheelEquip_license.txt")
shutil.copyfile("./ScrollWheelEquip/readmes/ScrollWheelEquip_changelog.txt", dirname + "/readmes/ScrollWheelEquip_changelog.txt")

# Create release zip
zip_name_ver = user_input.replace(".", "_")
shutil.make_archive("./ScrollWheelEquip_" + zip_name_ver + "_Release", format="zip", root_dir=dirname)
shutil.move("./ScrollWheelEquip_" + zip_name_ver + "_Release.zip", dirname + "/ScrollWheelEquip_" + zip_name_ver + "_Release.zip")
print "Created " + dirname + "/ScrollWheelEquip_" + zip_name_ver + "_Release.zip"

shutil.copyfile("./ScrollWheelEquip/Interface/Translations/ScrollWheelEquip_ENGLISH.txt", dirname + "/Interface/Translations/ScrollWheelEquip_ENGLISH.txt")

# Clean Up
print "Removing temp files..."
shutil.rmtree("./tmp")

print "Done!"
