CLASS zcl_todo_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    METHODS add_task
        IMPORTING
            i_title TYPE string
            i_description TYPE string
            i_priority TYPE i.
    METHODS mark_done
        IMPORTING
            i_title TYPE string.

    METHODS delete_task
        IMPORTING
            i_title TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_task,
               title       TYPE string,
               description TYPE string,
               priority    TYPE i,
               is_done     TYPE abap_bool,
          END OF ty_task.
    DATA mt_tasks TYPE STANDARD TABLE OF ty_task WITH DEFAULT KEY.
ENDCLASS.



CLASS zcl_todo_manager IMPLEMENTATION.
    METHOD add_task.
        "Eine neue Aufgabe anlegen
        DATA(ls_task) = VALUE ty_task(
            title   = i_title
            description = i_description
            priority    = i_priority
            is_done = abap_false
            ).
         "Aufgabe in die interne Tabelle einfügen
         INSERT ls_task INTO TABLE mt_tasks.

     ENDMETHOD.

     METHOD if_oo_adt_classrun~main.

         "Objekt der eigenen Klasse erzeugen
         DATA(lo_todo)  = NEW zcl_todo_manager( ).

         "Zwei Beispielaufgaben anlegen
         lo_todo->add_task(
            i_title = 'ABAP lernen'
            i_description = 'Erste Aufgabe für mein To-Do-Projekt'
            i_priority = 1
         ).

         lo_todo->add_task(
            i_title = 'Projekt erweitern'
            i_description = 'Weitere Funktionen für den To-Do-Manager'
            i_priority = 2
         ).

         "ABAP lernen als erledigt markieren
         lo_todo->mark_done(
            i_title = 'ABAP lernen'
         ).

         "Ausgabe der internen Tabelle
         out->write( lo_todo->mt_tasks ).

         "Löschen einer Aufgabe
         lo_todo->delete_task(
            i_title = 'Projekt erweitern'
          ).

         "Ausgabe nach dem Löschen
         out->write( lo_todo->mt_tasks ).

     ENDMETHOD.

     METHOD mark_done.
        LOOP AT mt_tasks ASSIGNING FIELD-SYMBOL(<ls_task>)
            WHERE title = i_title.

            <ls_task>-is_done = abap_true.
            RETURN.
        ENDLOOP.

      ENDMETHOD.

      METHOD delete_task.

        LOOP AT mt_tasks ASSIGNING FIELD-SYMBOL(<ls_task>)
            WHERE title = i_title.

            "Aktuelle Zeile löschen
            DELETE mt_tasks INDEX sy-tabix.
            RETURN.
        ENDLOOP.
      ENDMETHOD.

ENDCLASS.

