# Legacy-Code-Integrator-For-Simulink
### O extensie integrată cu Matlab pentru a adăuga cod C/C++ în modelele Simulink

Deseori în **Simulink** blocurile deja existente nu satisfac 100% cerințele creării unor caracteristici mai complexe și de aceea se folosesc înlățuiri de blocuri impractice. În unele cazuri, crearea codului **C/C++** poate fi mai intuitivă sau chiar se poate folosi cod pre-existent din librării.

Pentru a adăuga codul **C/C++** în model se folosește un bloc _container_ denumit **S-Function** ce va conține informații despre codul compilat. Problema apare la compilarea codului spre a fi înțeles de **Simulink**.

Compilarea codului **C/C++** spre a fi înțeles de **Simulink** necesită o aplicație integrată în **Matlab** denumită **Legacy Code**. Folosirea acestei aplicații se poate dovedi greoaie deoarece necesită popularea de mână a unei structuri și de indicarea exactă a ceea ce se dorește a fi făcut.

**Legacy Code Integrator for Simulink** este un o extensie peste aplicația **Legacy Code** ce oferă funcționalități intuitive spre a compila codul și spre a-l integra în **Simulink**. Aceasta va fi prezentă în meniul contextual al **Simulink**-ului sub forma unor opțiuni de adăugare, înlocuire bloc pre-existent, salvare a blocului nou creat spre o folosire ulterioară. Deasemenea, atunci când se înlocuiește un bloc pre-existent, se va face și o verificare a tipurilor de intrare/ieșire și se vor adăuga blocurile de conversie automat dacă tipurile înlocuite nu se potrivesc.
