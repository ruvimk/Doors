@echo off 
echo reset - The Service For Resetting The ISO Image 
copy CD\CD.ISO .
erase test_f.ISO
ren CD.ISO test_f.ISO
@echo on 