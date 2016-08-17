MatlabUML
=========

This is a small tool to automatically create an UML class diagram from MATLAB code.

Requirements
------------

  * a reasonably recent version of MATLAB
  * [graphviz](http://www.graphviz.org)
  * rdir (included)

Features
--------

  * create UML class diagram from code automatically
  * output into any format supported by graphviz (png, pdf, svg, ...)
  * supports public and private properties and methods
  * supports multiple inhertiance
  * supports recursive handling of classes in subfolders
  * uses MATLAB's meta.class feature instead of employing its own parser

Usage
-----
Set the `folder` variable to the folder containing the classes and the `output` variable to the desired output filename (withot extension). Make sure that the `dotExecutable` Variable points to the path where the dot tool from graphviz can be found.

Once all is set, just run uml.m. You can change the output format by modifying the call to the dot executable at the end of uml.m.

Limitations
-----------

  * function parameters and return values are not shown
  * GetAccess/SetAccess are not distinguished

License
-------

MatlabUML is licensed under the GPLv3 license.

Contact
-------

Author: Gerhard Kurz

Mail: gerhard.kurz (at) kit (dot) edu

Web: [http://isas.uka.de/User:Kurz](http://isas.uka.de/User:Kurz)
