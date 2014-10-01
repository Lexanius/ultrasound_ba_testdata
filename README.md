Ultrasound bachelor thesis Testdata
======================

All Data from Measurements with the Nao. Test the Ultrasound Sensors for my bachelor thesis.

Generate pdf from tex
-----------

make

Interprete Data via USTest
----------

to make .txt to tex  

Generate on test (PATH)
java -jar USTest.jar --oL=OUT/PATH --clearpage PATH/hybrid.mitte.nt.1.120.*  

Generate one matrix.tex
java -jar USTest.jar --oL=OUT/matrix_col_4_down --nA --nofn --clearpage --mode=parse.latex matrix/feld_4/helo.pos_2.no_jersey.robot_down.*  

Generate all matrix *.tex:
java -jar USTest.jar --sOut=OUT/ --mode=filter matrix/feld_*/*.normal.txt

Gerate images:  
java -jar USTest.jar --mode=cboth --nofn --orMPath=. --or=2 matrix.txt  

