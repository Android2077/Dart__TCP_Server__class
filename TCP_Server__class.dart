import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';    //для "Uint8List"




//***********************************
enum insert_flag
    {
  Before,
  After,
}
class STD_LIST_Iterator<T>
{

  //--------------------------Public:------------------------------

  STD_LIST_Iterator(this._value);

  T get__value()
  {
    return _value;
  }

  void set__value(T value_)
  {
    _value = value_;
  }


  //--------------------------Private:------------------------------
  T _value;

  STD_LIST_Iterator<T>? _prev = null;
  STD_LIST_Iterator<T>? _next = null;
}
class STD_LIST__class<T>
{

  //-------------------------Private:egin----------------------
  STD_LIST_Iterator<T>? _Begin_Element_ref = null;

  STD_LIST_Iterator<T>? _Last_Element_ref = null;

  int _Size = 0;
  //-------------------------Private:end----------------------
/*
  iterration_lopp
  range_iterrator_count
  begin
  last
  get__Element_by_Index_From_Begin__Slowly
  push_back
  push_front
  insert
  insert_range
  pop_back
  pop_front
  erase
  erase_range
  std_next
  std_prev
  std_prev_advanced
  std_prev_advanced
  splice__move_one_element
  splice__move_range_element
  clear
  size
  */

  void iterration_lopp(STD_LIST_Iterator<T>? First_Range_it, STD_LIST_Iterator<T>? Last_Range_it, bool Function(STD_LIST__class<T> class_ref, STD_LIST_Iterator<T>) user_func)
  {

    if(First_Range_it != null && Last_Range_it != null)
    {

      //----------------------------------------------
      STD_LIST_Iterator<T> temp_it = First_Range_it!;
      //----------------------------------------------


      //----------------------------------------------------
      while (temp_it != Last_Range_it)
      {
        final bool res = user_func(this, temp_it);

        if (res == false)
        {
          return; //Значит Пользователь возвратил сообщение из функции, что он хочет завершить итерацию.
        }

        temp_it = temp_it._next!;
      }

      user_func(this, temp_it);
      //----------------------------------------------------
    }

  }

  int range_iterrator_count(STD_LIST_Iterator<T>? First_Range_it, STD_LIST_Iterator<T>? Last_Range_it)
  {


    if(First_Range_it != null && Last_Range_it != null)
    {

      //----------------------------------------------
      int cntr = 0;
      STD_LIST_Iterator<T> temp_it = First_Range_it!;
      //----------------------------------------------


      //----------------------------------------------------
      for (;;)
      {
        //----------------------------------
        cntr++;

        temp_it = temp_it._next!;

        if (temp_it == Last_Range_it)
        {
          cntr++; //Прибавляем заключительную итерацию.

          return cntr;
        }
        //----------------------------------

      }
      //----------------------------------------------------

    }
    else
    {
      return 0;
    }

  }

  STD_LIST_Iterator<T>? begin()
  {
    return _Begin_Element_ref;
  }

  STD_LIST_Iterator<T>? last()
  {
    return _Last_Element_ref;
  }

  STD_LIST_Iterator<T>? get__Element_by_Index_From_Begin__Slowly(int Index)
  {

    //-----------------------------
    if(Index >= _Size)
    {
      return null;
    }
    //-----------------------------


    //-----------------------------------------------------------------
    int cntr = 0;

    STD_LIST_Iterator<T> it = _Begin_Element_ref!;

    for(int i = 0; i < Index; i++ )
    {
      it = it._next!;
    }
    //-----------------------------------------------------------------

    return it;

  }

  STD_LIST_Iterator<T>? get__Element_by_Index_From_Iterator__Slowly(STD_LIST_Iterator<T>? user_it, insert_flag insert_flag_, int Index)
  {

    int cntr = 0;

    if(insert_flag_ == insert_flag.Before)
    {

      //-----------------------------------------------------------------
      STD_LIST_Iterator<T>? it = user_it;

      for(int i = 0; i < Index; i++ )
      {
        if(it!._prev == null)
        {
          return null;
        }

        it = it._prev!;
      }
      //-----------------------------------------------------------------

      return it;

    }
    else
    {

      //-----------------------------------------------------------------
      STD_LIST_Iterator<T>? it = user_it;

      for(int i = 0; i < Index; i++ )
      {
        if(it!._next == null)
        {
          return null;
        }

        it = it._next!;
      }
      //-----------------------------------------------------------------

      return it;

    }



  }

  void push_back(T value)
  {
    final new_element = new STD_LIST_Iterator(value); //выделяем память под элемент.

    _push_back_iterrator(new_element, true);
  }

  void push_front(T value)
  {
    final new_element = new STD_LIST_Iterator(value); //выделяем память под элемент.

    _push_front_iterrator(new_element, true);
  }

  STD_LIST_Iterator<T> insert(STD_LIST_Iterator<T>? Iterrator_to_Elem, insert_flag insert_flag_, T value)
  {
    //Iterrator_to_Elem   - ссылка на уже добавленный и существуюший элемент в Списке.
    //insert_flag_        - флаг добавления: before - значит доавбить элемент "value" ДО элемента "Iterrator_to_Elem" в списке; after - значит доавбить элемент "value" ПОСЛЕ элемента "Iterrator_to_Elem" в списке.

    final new_element = new STD_LIST_Iterator(value); //выделяем память под элемент.

    return _insert_iterrator(Iterrator_to_Elem!, insert_flag_, new_element, true);
  }

  STD_LIST_Iterator<T> insert_range(STD_LIST_Iterator<T>? Iterrator_to_Elem, insert_flag insert_flag_, List<T> vec_value)
  {
    //Iterrator_to_Elem   - ссылка на уже добавленный и существуюший элемент в Списке.
    //insert_flag_        - флаг добавления: before - значит доавбить элемент "value" ДО элемента "Iterrator_to_Elem" в списке; after - значит доавбить элемент "value" ПОСЛЕ элемента "Iterrator_to_Elem" в списке.


    //----------------------------------------------------------------------------------------
    final List<STD_LIST_Iterator<T>> vec__new_elements = List.generate(vec_value.length, (index)
    {
      return new STD_LIST_Iterator<T>(vec_value[index]);
    });
    //----------------------------------------------------------------------------------------



    //----------------------------------------------------------------------------------------
    for(int i=0; i < vec__new_elements.length; i++ )
    {
      if(i < (vec__new_elements.length - 1))
      {
        vec__new_elements[i]._next   = vec__new_elements[i+1];
        vec__new_elements[i+1]._prev = vec__new_elements[i];
      }
    }
    //----------------------------------------------------------------------------------------



    return _insert_iterrator_range(Iterrator_to_Elem!, insert_flag_, vec__new_elements.first, vec__new_elements.last, true);
  }



  void pop_back()
  {

    //-------------------------------
    if(_Size == 0)
    {
      return;
    }
    //-------------------------------


    final STD_LIST_Iterator<T> removed_Element = _Last_Element_ref!;  // Сохраняем ссылку на удаляемый элемент, чтобы обнулить его связи


    //-------------------------------
    if(_Size == 1)
    {
      _Begin_Element_ref = null;
      _Last_Element_ref  = null;
    }
    else
    {
      (_Last_Element_ref!._prev)!._next = null;

      _Last_Element_ref = _Last_Element_ref!._prev;
    }
    //-------------------------------


    _Size = _Size-1;


    //----------------------------------
    removed_Element._next = null;
    removed_Element._prev = null;
    //----------------------------------

  }

  void pop_front()
  {

    //-------------------------------
    if(_Size == 0)
    {
      return;
    }
    //-------------------------------


    final STD_LIST_Iterator<T> removed_Element = _Begin_Element_ref!;  // Сохраняем ссылку на удаляемый элемент, чтобы обнулить его связи


    //-------------------------------
    if(_Size == 1)
    {
      _Begin_Element_ref = null;
      _Last_Element_ref  = null;
    }
    else
    {
      (_Begin_Element_ref!._next)!._prev = null;

      _Begin_Element_ref = _Begin_Element_ref!._next;
    }
    //-------------------------------


    _Size = _Size-1;


    //----------------------------------
    removed_Element._next = null;
    removed_Element._prev = null;
    //----------------------------------

  }


  STD_LIST_Iterator<T>? erase(STD_LIST_Iterator<T>? Iterrator_to_Elem)
  {
    return _erase_iterrator(Iterrator_to_Elem!, true);
  }

  STD_LIST_Iterator<T>? erase_range(STD_LIST_Iterator<T>? First_Range_it, STD_LIST_Iterator<T>? Last_Range_it)
  {
    return _erase_iterrator_Range(First_Range_it!, Last_Range_it!, true);
  }


  STD_LIST_Iterator<T>? std_next_with_null(STD_LIST_Iterator<T>? Iterrator_to_Elem)
  {
    if(Iterrator_to_Elem == null)
    {
      return _Begin_Element_ref;
    }
    else
    {
      return Iterrator_to_Elem!._next;
    }
  }

  STD_LIST_Iterator<T>? std_next(STD_LIST_Iterator<T>? Iterrator_to_Elem)
  {
    return Iterrator_to_Elem!._next;
  }

  STD_LIST_Iterator<T>? std_prev(STD_LIST_Iterator<T>? Iterrator_to_Elem)
  {
    return Iterrator_to_Elem!._prev;
  }

  STD_LIST_Iterator<T>? std_next_advanced_with_null(STD_LIST_Iterator<T>? Iterrator_to_Elem, int num_step)
  {

    if(Iterrator_to_Elem == null)
    {
      return _Begin_Element_ref;
    }
    else
    {
      return std_next_advanced(Iterrator_to_Elem, num_step);
    }

  }

  STD_LIST_Iterator<T>? std_next_advanced(STD_LIST_Iterator<T>? Iterrator_to_Elem, int num_step)
  {

    STD_LIST_Iterator<T> it_temp = Iterrator_to_Elem!;

    //-------------------------------------
    for(int i = 0; i < num_step; i++ )
    {

      if(it_temp._next == null)
      {
        return null;
      }

      it_temp = it_temp._next!;
    }
    //-------------------------------------

    return it_temp;
  }

  STD_LIST_Iterator<T>? std_prev_advanced(STD_LIST_Iterator<T>? Iterrator_to_Elem, int num_step)
  {

    STD_LIST_Iterator<T> it_temp = Iterrator_to_Elem!;

    //-------------------------------------
    for(int i = 0; i < num_step; i++ )
    {

      if(it_temp._prev == null)
      {
        return null;
      }

      it_temp = it_temp._prev!;
    }
    //-------------------------------------

    return it_temp;

  }

  void splice__move_one_element(STD_LIST_Iterator<T>? iterator_where_to_move, insert_flag insert_flag_, STD_LIST_Iterator<T>? which_iterator_to_move)
  {
    //Данная функция перемещает один итератор "which_iterator_to_move" в позицию итератора "iterator_where_to_move" с установление флага пермещения "insert_flag_" ДО[то есть СЛЕВА] или ПОСЛЕ[то есть СПРАВА] итератора "iterator_where_to_move".

    _erase_iterrator(which_iterator_to_move!, false);

    _insert_iterrator(iterator_where_to_move!, insert_flag_, which_iterator_to_move, false);
  }

  void splice__move_range_element(STD_LIST_Iterator<T>? iterator_where_to_move, insert_flag insert_flag_, STD_LIST_Iterator<T>? first, STD_LIST_Iterator<T>? last)
  {

    //Данная функция перемещает диапазон итераторов от "first" до "last" в позицию итератора "iterator_where_to_move" с установление флага пермещения "insert_flag_" ДО или ПОСЛЕ итератора "iterator_where_to_move".
    //Если пермещение диапазона [first-last] происходит ДО "iterator_where_to_move", то диапазон "вставляется" крайним итерратором "last" прилиегающим ДО итератора, то есть СЛЕВА "iterator_where_to_move":  [first-last][iterator_where_to_move]
    //Если пермещение диапазона [first-last] происходит ПОСЛЕ "iterator_where_to_move", то диапазон "вставляется" крайним итерратором "first" прилиегающим ПОСЛЕ итератора, то есть СПРАВА "iterator_where_to_move":  [iterator_where_to_move][first-last]

    _erase_iterrator_Range(first!, last!, false);

    _insert_iterrator_range(iterator_where_to_move!, insert_flag_, first!, last!, false);
  }

  void splice__move_one_external_STD_LIST(STD_LIST_Iterator<T> iterator_where_to_move, insert_flag insert_flag_, STD_LIST__class<T> which_STD_LIST_to_move)
  {

    //Данная функция перемещает другой существующий списк "STD_LIST" "which_STD_LIST_to_move" в данный "STD_LIST" в позицию итератора данного "STD_LIST" "iterator_where_to_move" с установление флага пермещения "insert_flag_" ДО[то есть СЛЕВА] или ПОСЛЕ[то есть СПРАВА] итератора "iterator_where_to_move".

    //Лень, все равно никогда такое не использовал.
  }

  void splice__move_one_element_from_external_STD_LIST(STD_LIST_Iterator<T> iterator_where_to_move, insert_flag insert_flag_, STD_LIST__class<T> which_STD_LIST_to_move, STD_LIST_Iterator<T> which_iterator_to_move)
  {

    //Данная функция перемещает один итератор "which_iterator_to_move" из другого существующего списка "STD_LIST" "which_STD_LIST_to_move" в данный "STD_LIST" в позицию итератора данного "STD_LIST" "iterator_where_to_move" с установление флага пермещения "insert_flag_" ДО[то есть СЛЕВА] или ПОСЛЕ[то есть СПРАВА] итератора "iterator_where_to_move".

    //Лень, все равно никогда такое не использовал.
  }

  void splice__move_range_element_from_external_STD_LIST(STD_LIST_Iterator<T> iterator_where_to_move, insert_flag insert_flag_, STD_LIST__class<T> which_STD_LIST_to_move, STD_LIST_Iterator<T> first, STD_LIST_Iterator<T> last)
  {

    //Данная функция перемещает диапазон итераторов от "first" до "last" другого существующего списка "STD_LIST" "which_STD_LIST_to_move" в данный "STD_LIST" в позицию итератора "iterator_where_to_move" с установление флага пермещения "insert_flag_" ДО или ПОСЛЕ итератора "iterator_where_to_move".
    //Если пермещение диапазона [first-last] происходит ДО "iterator_where_to_move", то диапазон "вставляется" крайним итерратором "last" прилиегающим ДО итератора, то есть СЛЕВА "iterator_where_to_move":  [first-last][iterator_where_to_move]
    //Если пермещение диапазона [first-last] происходит ПОСЛЕ "iterator_where_to_move", то диапазон "вставляется" крайним итерратором "first" прилиегающим ПОСЛЕ итератора, то есть СПРАВА "iterator_where_to_move":  [iterator_where_to_move][first-last]

    //Лень, все равно никогда такое не использовал.
  }


  void clear()
  {
    _clear(true);
  }

  int size()
  {
    return _Size;
  }


  //-------------------------------------------------------Private:----------------------------------------------------------------------


  void _push_back_iterrator(STD_LIST_Iterator<T> it, bool chage_size_flag)
  {
    //it                  - итерратор, который добавляем.


    if (_Begin_Element_ref != null)
    {
      //Значит уже есть минимум один добавленный элемент.

      it._prev       =_Last_Element_ref;  //Указываем для нового эелмента ссылку на предыдущи элементй, то есть это последний элемент до вызова "push_back"
      _Last_Element_ref!._next = it;      //Указываем для предыдущего элементы ссылку на "next" на этот только что доавленный элемент. "!" - указывает компилятору, что "Last_Element_ref" точно не Null, иначе не хера не компилируется. Повыдумывают всякой хни.

      _Last_Element_ref        = it;      //Теперь ссылка на последний элемент - это этот добавленный элемент.

      if(chage_size_flag == true){_Size++;}

      return;
    }
    else
    {
      //Значит еще нет ни одного доавбленного элемента.

      _Begin_Element_ref = it;
      _Last_Element_ref  = _Begin_Element_ref;

      if(chage_size_flag == true){_Size++;}

      return;
    }

  }

  void _push_front_iterrator(STD_LIST_Iterator<T> it, bool chage_size_flag)
  {
    //it                  - итерратор, который добавляем.

    if (_Begin_Element_ref != null)
    {
      //Значит уже есть минимум один добавленный элемент.

      it._next                    = _Begin_Element_ref;   //Указываем для нового эелмента ссылку на следующий элементй, то есть это первый элемент в списке.
      _Begin_Element_ref!._prev   = it;                   //Указываем для первого элемента ссылку на его теперешний предыдущий "prev" - только что доавленный элемент. "!" - указывает компилятору, что "Last_Element_ref" точно не Null, иначе не хера не компилируется. Повыдумывают всякой хни.

      _Begin_Element_ref          = it;                    //Теперь ссылка на первый элемент - это этот добавленный элемент.

      if(chage_size_flag == true){_Size++;}

      return;
    }
    else
    {
      //Значит еще нет ни одного доавбленного элемента.

      _Begin_Element_ref = it;
      _Last_Element_ref  = _Begin_Element_ref;

      if(chage_size_flag == true){_Size++;}

      return;
    }

  }

  STD_LIST_Iterator<T> _insert_iterrator(STD_LIST_Iterator<T> Iterrator_to_Elem, insert_flag insert_flag_, STD_LIST_Iterator<T> it, bool chage_size_flag)
  {
    //Iterrator_to_Elem   - ссылка на уже добавленный и существуюший элемент в Списке.
    //insert_flag_        - флаг добавления: before - значит доавбить элемент "value" ДО элемента "Iterrator_to_Elem" в списке; after - значит доавбить элемент "value" ПОСЛЕ элемента "Iterrator_to_Elem" в списке.
    //it                  - итерратор, который добавляем.


    if(insert_flag_ == insert_flag.Before)
    {
      //Значит нужно вставить элемент "value" ДО элемента "Iterrator_to_Elem" в списке.

      if (_Size == 1)
      {
        //Значит это едисвенный элемент в списке:

        _push_front_iterrator(it, chage_size_flag);

        return it;
      }
      else
      {
        //Значит в списке минимум два элемента:

        if(Iterrator_to_Elem._prev == null)
        {
          //Значит это первый элемент в списке:

          _push_front_iterrator(it, chage_size_flag);

          return it;
        }
        else
        {

          //[Iterrator_to_Elem._prev]...[Iterrator_to_Elem]                                      //Текущие два элементуса
          //[Iterrator_to_Elem._prev]...<insert__temp_element__insert>...[Iterrator_to_Elem]     //Вставляем элемент "temp_element" между этими элементами, то есть ДО элмента "Iterrator_to_Elem"

          //---------------------------------------------------
          it._next = Iterrator_to_Elem;
          it._prev = Iterrator_to_Elem._prev;

          (Iterrator_to_Elem._prev)!._next = it;

          Iterrator_to_Elem._prev = it;
          //---------------------------------------------------

          if(chage_size_flag == true){_Size++;}

          return it;
        }

      }

    }
    else
    {
      //if(insert_flag_ == insert_flag.After)

      //Значит нужно вставить элемент "value" ПОСЛЕ элемента "Iterrator_to_Elem" в списке.

      if (_Size == 1)
      {
        //Значит это едисвенный элемент в списке:

        _push_back_iterrator(it, chage_size_flag);

        return it;
      }
      else
      {
        //Значит в списке минимум два элемента:

        if(Iterrator_to_Elem._next == null)
        {
          //Значит это последний элемент в списке:

          _push_back_iterrator(it, chage_size_flag);

          return it;
        }
        else
        {

          //[Iterrator_to_Elem]...[Iterrator_to_Elem._prev]                                      //Текущие два элементуса
          //[Iterrator_to_Elem]...<insert__temp_element__insert>...[Iterrator_to_Elem._next]     //Вставляем элемент "temp_element" между этими элементами, то есть ДО элмента "Iterrator_to_Elem"

          //---------------------------------------------------
          it._next = Iterrator_to_Elem._next;
          it._prev = Iterrator_to_Elem;

          (Iterrator_to_Elem._next)!._prev = it;

          Iterrator_to_Elem._next          = it;
          //---------------------------------------------------

          if(chage_size_flag == true){_Size++;}

          return it;
        }
      }
    }

  }
  STD_LIST_Iterator<T> _insert_iterrator_range(STD_LIST_Iterator<T> Iterrator_to_Elem, insert_flag insert_flag_, STD_LIST_Iterator<T> First_Range_it, STD_LIST_Iterator<T> Last_Range_it, bool chage_size_flag)
  {
    //Iterrator_to_Elem   - ссылка на уже добавленный и существуюший элемент в Списке.
    //insert_flag_        - флаг добавления: before - значит доавбить элемент "value" ДО элемента "Iterrator_to_Elem" в списке; after - значит доавбить элемент "value" ПОСЛЕ элемента "Iterrator_to_Elem" в списке.


    //--------------------------------
    if(First_Range_it == Last_Range_it)
    {
      return _insert_iterrator(Iterrator_to_Elem, insert_flag_, First_Range_it, chage_size_flag);
    }
    else
    {
      if (insert_flag_ == insert_flag.Before)
      {
        if(Iterrator_to_Elem._prev == null)
        {
          //Значит вставляем диапазон итераторов от начала ДО "Iterrator_to_Elem":

          _Begin_Element_ref        = First_Range_it;
          _Begin_Element_ref!._prev = null;

          Last_Range_it._next       = Iterrator_to_Elem;
          Iterrator_to_Elem._prev   = Last_Range_it;
        }
        else
        {
          //Значит вставляем диапазон итераторов в "середину" списка ДО "Iterrator_to_Elem":

          (Iterrator_to_Elem._prev)!._next = First_Range_it;
          First_Range_it._prev             = Iterrator_to_Elem._prev;

          Iterrator_to_Elem._prev          = Last_Range_it;
          Last_Range_it._next              = Iterrator_to_Elem;
        }
      }
      else
      {
        if(Iterrator_to_Elem._next == null)
        {
          //Значит вставляем диапазон итераторов ПОСЛЕ последнего элемента "Iterrator_to_Elem" в списке:

          _Last_Element_ref        = Last_Range_it;
          _Last_Element_ref!._next = null;

          First_Range_it._prev      = Iterrator_to_Elem;
          Iterrator_to_Elem._next   = First_Range_it;
        }
        else
        {
          //Значит вставляем диапазон итераторов в "середину" списка ПОСЛЕ "Iterrator_to_Elem":

          (Iterrator_to_Elem._next)!._prev  = Last_Range_it;
          Last_Range_it._next               = Iterrator_to_Elem._next;

          Iterrator_to_Elem._next           = First_Range_it;
          First_Range_it._prev              = Iterrator_to_Elem;
        }
      }

      //----------------------------------------
      if(chage_size_flag == true)
      {
        int count = range_iterrator_count(First_Range_it, Last_Range_it);  //Получим кол-во элементов в диапазоне итераторов First-Last.

        _Size = _Size + count;
      }
      //----------------------------------------

      return First_Range_it;

    }
  }




  STD_LIST_Iterator<T>? _erase_iterrator(STD_LIST_Iterator<T> Iterrator_to_Elem, bool chage_size_flag)
  {

    //Функция возвращает итератор на следющий элемент за удалнным элементом.

    if(Iterrator_to_Elem!._next == null)
    {
      //Значит это Последний элемент в списке.

      pop_back();   //Удаляем Последний элемент.

      return null;   //Возвращем null, так как "После" удаленного элемента ничего нет - так как он был послденим.
    }
    else
    {
      if(Iterrator_to_Elem!._prev == null)
      {
        //Значит это Первый элемент в списке.

        pop_front();      //Удаляем Последний элемент.

        return _Begin_Element_ref;   //Возвращаем "итерраотр" на первый элемент, так элемент, который следовал за Удаляемым элементом - теперь стал первым.
      }
      else
      {
        //Значит это Ни Первый и Не Последний элемент в списке.

        //-----------------------------------------------------------------
        final STD_LIST_Iterator<T> removed_Element = Iterrator_to_Elem;           // Сохраняем ссылку на удаляемый элемент, чтобы обнулить его связи
        final STD_LIST_Iterator<T> return_Element  = Iterrator_to_Elem._next!;    // Сохраняем ссылку на Следующий за удаляемым элементом, для его возврата из функции.
        //-----------------------------------------------------------------


        //---------------------------------------------------------------
        (Iterrator_to_Elem!._next)!._prev = Iterrator_to_Elem._prev;

        (Iterrator_to_Elem!._prev)!._next = Iterrator_to_Elem._next;
        //---------------------------------------------------------------


        //----------------------------------
        if(chage_size_flag == true)
        {
          removed_Element._next = null;
          removed_Element._prev = null;

          _Size = _Size - 1;
        }
        //----------------------------------

        return return_Element;
      }
    }

  }
  STD_LIST_Iterator<T>? _erase_iterrator_Range(STD_LIST_Iterator<T> First_Range_it, STD_LIST_Iterator<T> Last_Range_it, bool chage_size_flag)
  {

    //Функция возвращает итератор на следющий элемент за последним удалнным элементом диапазона.


    //----------------------------------------------
    if(First_Range_it == Last_Range_it)
    {
      return _erase_iterrator(First_Range_it, chage_size_flag);
    }
    //----------------------------------------------



    //----------------------------------------------
    if(First_Range_it._prev == null && Last_Range_it._next == null)
    {
      //Значит весь диапазон списка:

      _clear(chage_size_flag);

      return null;
    }
    else
    {
      if(First_Range_it._prev == null && Last_Range_it._next != null)
      {
        //Значит от Первого элемента до "Середины":

        //------------------------------------------
        _Begin_Element_ref = Last_Range_it._next;
        _Begin_Element_ref!._prev = null;
        //------------------------------------------


        STD_LIST_Iterator<T> temp_it      = First_Range_it;
        STD_LIST_Iterator<T> temp_it_next;


        //----------------------------------------
        if(chage_size_flag == true)
        {
          int count = range_iterrator_count(First_Range_it, Last_Range_it);  //Получим кол-во элементов в диапазоне итераторов First-Last.

          _Size = _Size - count;
        }
        //----------------------------------------

        for(;;)
        {
          temp_it_next = temp_it._next!;

          //------------------------
          if(chage_size_flag == true)
          {
            temp_it._prev = null;
            temp_it._next = null;
          }
          //------------------------

          if(temp_it_next == Last_Range_it)
          {
            //Значит это "Last_Range_it":

            //------------------------
            if(chage_size_flag == true)
            {
              temp_it_next._prev = null;
              temp_it_next._next = null;
            }
            //------------------------

            return _Begin_Element_ref;
          }

          temp_it = temp_it_next;
        }

      }
      else
      {
        if(First_Range_it._prev != null && Last_Range_it._next == null)
        {
          //Значит от "Середины" до Последнего элемента:


          //------------------------------------------
          _Last_Element_ref = First_Range_it._prev;
          _Last_Element_ref!._next = null;
          //------------------------------------------

          STD_LIST_Iterator<T> temp_it      = First_Range_it;
          STD_LIST_Iterator<T> temp_it_next;


          //----------------------------------------
          if(chage_size_flag == true)
          {
            int count = range_iterrator_count(First_Range_it, Last_Range_it);  //Получим кол-во элементов в диапазоне итераторов First-Last.

            _Size = _Size - count;
          }
          //----------------------------------------


          for(;;)
          {
            temp_it_next = temp_it._next!;

            //------------------------
            if(chage_size_flag == true)
            {
              temp_it._prev = null;
              temp_it._next = null;
            }
            //------------------------

            if(temp_it_next == Last_Range_it)
            {
              //Значит это "Last_Range_it":

              //------------------------
              if(chage_size_flag == true)
              {
                temp_it_next._prev = null;
                temp_it_next._next = null;
              }
              //------------------------

              return null;
            }

            temp_it = temp_it_next;
          }

        }
        else
        {
          //Значит Первый и Последний элементы не затрагиваются: то есть удаляем кусок из "Середины":

          //------------------------------------------
          (First_Range_it._prev!)._next      = Last_Range_it._next;
          (Last_Range_it._next!)._prev       = First_Range_it._prev;

          STD_LIST_Iterator<T> it_for_return = Last_Range_it._next!;
          //------------------------------------------

          STD_LIST_Iterator<T> temp_it      = First_Range_it;
          STD_LIST_Iterator<T> temp_it_next;

          for(;;)
          {
            temp_it_next = temp_it._next!;

            //------------------------
            if(chage_size_flag == true)
            {
              temp_it._prev = null;
              temp_it._next = null;
            }
            //------------------------

            if(temp_it_next == Last_Range_it)
            {
              //Значит это "Last_Range_it":

              //------------------------
              if(chage_size_flag == true)
              {
                temp_it_next._prev = null;
                temp_it_next._next = null;
              }
              //------------------------

              //----------------------------------------
              if(chage_size_flag == true)
              {
                int count = range_iterrator_count(First_Range_it, Last_Range_it);  //Получим кол-во элементов в диапазоне итераторов First-Last.

                _Size = _Size - count;
              }
              //----------------------------------------

              return it_for_return;
            }

            temp_it = temp_it_next;
          }

        }
      }

    }
    //----------------------------------------------

  }

  void _clear(bool chage_size_flag)
  {

    if(chage_size_flag == true)
    {

      //--------------------------------------
      if(_Size == 1)
      {
        _Begin_Element_ref!._prev = null;
        _Begin_Element_ref!._next = null;

        _Begin_Element_ref = null;
        _Last_Element_ref  = null;

        _Size = 0;

        return;
      }
      //--------------------------------------


      STD_LIST_Iterator<T>? temp_it      = _Begin_Element_ref;
      STD_LIST_Iterator<T>? temp_it_next;


      for(;;)
      {

        temp_it_next = temp_it!._next;

        //------------------------
        temp_it._prev = null;
        temp_it._next = null;
        //------------------------

        if (temp_it_next == _Last_Element_ref)
        {
          //Значит это Последний элемент:

          //------------------------
          temp_it_next!._prev = null;
          temp_it_next!._next = null;
          //------------------------

          break;
        }

        temp_it = temp_it_next;
      }

      _Begin_Element_ref = null;
      _Last_Element_ref  = null;

      _Size = 0;
    }
    else
    {
      _Begin_Element_ref!._prev = null;
      _Begin_Element_ref!._next = null;

      _Begin_Element_ref = null;
      _Last_Element_ref  = null;
    }


  }

}
//***********************************

//***********************************
class Uint8List__class
{

  Uint8List__class()
  {
    initialization();
  }

  void initialization()
  {
    _Uint8List_ref = Uint8List(0);
  }

  void set__Reserve_koef(double value)
  {
    _reserve_koef = value;
  }

  //----------------------------------------------Public:Begin--------------------------------------------------------------
  void set_Buffer_Wrap_around_class(Uint8List Uint8List_, int size)
  {
    //Делаем переданный "Uint8List_" - как бы частью данного класса.

    _Uint8List_ref = Uint8List_;

    _size           = size;
    _capacity_size  = Uint8List_.length;
  }

  void set_Buffer_Value(Uint8List Uint8List_, int size)
  {
    //Делаем копию "Uint8List_".

    resize(size);

    memcpy(_Uint8List_ref!, 0, Uint8List_, 0, size);
  }

  void insert(int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size, insert_flag insert_flag_)
  {

    //Index_element_to_Insert - индекс Элемента в буффере "_Uint8List_ref" отсносительно которого нужно осуществить вставку "Uint8List_insert"
    //InserFlag:                -флаг вставки: Before - значит Uint8List_insert нужно вставить ДО указанного Index_element_to_Insert; After - значит Uint8List_insert нужно вставить После указанного Index_element_to_Insert;



    //---------------------------------------------------------
    if (insert_flag_ == insert_flag.After)
    {
      //After:

      //---------------------------------------------------------
      if((_capacity_size - _size) < insert_size)
      {
        //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

        Uint8List Uint8List_NewBuffer = _new_alloc__Without_Copy(_size + insert_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_insert" и перекопируем туда существуте элементы.

        _insert_After_with_NewBuffer(Uint8List_NewBuffer, _Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);

        _Uint8List_ref = Uint8List_NewBuffer;
      }
      else
      {
        //Значит емкости для вставки хватает:

        if(Index_element_to_Insert == (_size-1))
        {
          //Значит по сути делаем push_back:

          _push_back__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_insert, insert_size);
        }
        else
        {
          //Значит вставка в середину ПОСЛЕ указанного индекса элемента "Index_element_to_Insert":

          _insert_After_with_CurrentBuffer(_Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);
        }

      }
      //---------------------------------------------------------

    }
    else
    {
      //Before:

      //---------------------------------------------------------
      if((_capacity_size - _size) < insert_size)
      {
        //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

        Uint8List Uint8List_NewBuffer = _new_alloc__Without_Copy(_size + insert_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_insert" и перекопируем туда существуте элементы.

        _insert_Before_with_NewBuffer(Uint8List_NewBuffer, _Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);

        _Uint8List_ref = Uint8List_NewBuffer;
      }
      else
      {
        //Значит емкости для вставки хватает:

        if(Index_element_to_Insert == 0)
        {
          //Значит по сути делаем push_front:

          _push_front__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_insert, insert_size);
        }
        else
        {
          //Значит вставка в середину ДО указанного индекса элемента "Index_element_to_Insert":

          _insert_Before_with_CurrentBuffer(_Uint8List_ref!, _size, Index_element_to_Insert, Uint8List_insert, insert_size);
        }

      }
      //---------------------------------------------------------

    }
    //---------------------------------------------------------


    _size = _size + insert_size;

  }

  void insert_OneValue(int Index_element_to_Insert, int value, insert_flag insert_flag_)
  {

    Uint8List Uint8List_ = Uint8List(1);
    Uint8List_[0]        = value;

    insert(Index_element_to_Insert, Uint8List_, 1, insert_flag_);
  }

  void push_back(Uint8List Uint8List_add, int add_size)
  {


    //---------------------------------------------------------
    if((_capacity_size - _size) < add_size)
    {
      //Значит место для записи Не хватает: выделим новую память с запасом и перекопируем туда все данные.

      _new_alloc__With_Copy(_size + add_size, _reserve_koef);   //Выделим новую память с учетом размера "Uint8List_add" и перекопируем туда существуте элементы.
    }

    //---------------------------------------------------------

    //---------------------------------------------------------------
    _push_back__CurrentBuffer(_Uint8List_ref!, _size, Uint8List_add, add_size);                                  //Копируем данные из "Uint8List_add" в конец "_Uint8List_ref".
    //---------------------------------------------------------------

    //---------------------------------------------------------------
    _size = _size + add_size;
    //---------------------------------------------------------------

  }

  void push_back_OneValue(int value)
  {
    Uint8List Uint8List_ = Uint8List(1);
    Uint8List_[0]        = value;

    push_back(Uint8List_,1);
  }

  void set_Buffer_Value_by_UTF8_from_String(String String_)
  {
    //Данный метод только для однобайтного типа

    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    set_Buffer_Value(Uint8List_, Uint8List_.length);
  }

  void push_back_from_String(String String_)
  {
    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    push_back(Uint8List_, Uint8List_.length);
  }

  void insert_from_String(String String_, int Index_element_to_Insert, insert_flag insert_flag_)
  {
    final Uint8List Uint8List_ = Uint8List.fromList(utf8.encode(String_));

    insert(Index_element_to_Insert, Uint8List_, Uint8List_.length, insert_flag_);
  }


  void pop_back(int delete_size)
  {
    _size = _size - delete_size;
  }

  void erase(int Index_Erase_element)
  {

    if(Index_Erase_element == _size-1)
    {
      pop_back(1);
    }
    else
    {
      memcpy(_Uint8List_ref!, Index_Erase_element, _Uint8List_ref!, Index_Erase_element + 1, (_size -Index_Erase_element - 1));

      _size = _size - 1;
    }

  }
  void erase_range(int Index_Erase_element_First, int Index_Erase_element_End)
  {

    if(Index_Erase_element_End == _size-1)
    {
      _size = _size - (Index_Erase_element_End - Index_Erase_element_First + 1);
    }
    else
    {

      //----------------------------------------------------------------------------
      memcpy(_Uint8List_ref!, Index_Erase_element_First, _Uint8List_ref!, Index_Erase_element_End + 1, (_size - Index_Erase_element_End) - 1);
      //----------------------------------------------------------------------------

      _size = _size - (Index_Erase_element_End - Index_Erase_element_First + 1);
    }

  }


  void erase_if(bool Function(int value_compare) user_func_condition)
  {

    //-------------------------
    int read_index  = 0;
    int write_index = 0;

    int current_value;
    //-------------------------

    //-------------------------------------------------------------------
    for (read_index = 0; read_index < _size; read_index++)
    {

      current_value = _Uint8List_ref![read_index];

      bool delete_flag = user_func_condition(current_value);

      //````````````````````````````````````````````````
      if (delete_flag == false)
      {

        if (read_index != write_index)
        {
          _Uint8List_ref![write_index] = current_value;
        }

        write_index++;
      }
      //````````````````````````````````````````````````

    }
    //-------------------------------------------------------------------


    _size = write_index;

  }


  void memcpy(Uint8List Uint8List_to_Copy, int index_to_Copy, Uint8List Uint8List_from_Copy, index_from_Copy, int size_copy)
  {
    //Uint8List_to_Copy       - Буффер куда нужно копировать данные из "Uint8List_from_Copy"
    //index_to_Copy           - Индекс элемента в буффере "Uint8List_to_Copy" куда нужно скопировать даныне из буффера "Uint8List_from_Copy".
    //Uint8List_from_Copy     - Буффер "Uint8List" откуда нужно скопировать данные.
    //index_from_Copy         - индекс элемента из буффера "index_from_Copy" откуда нужно скопировать элементы в размере "size_copy".


    //-----------------------------------------------------------------------------
    //Первый параметр: это Индекс элемента в буффере "Uint8List_to_Copy" с которого нужно начать вставлять данные из "Uint8List_from_Copy";
    //Второй параметр: это индекс элемента в буффере "Uint8List_to_Copy" ДО которого [НЕ Включая] нужно скпировать элементы из "Uint8List_from_Copy".
    //ТО ЕСТЬ - если нужно к примеру скоировать данные в буффер "Uint8List_to_Copy" со 2 элемента по 4 - то есть три элемента: 2,3,4 - то нужно указать: первым парметром - 1, а вторым парметром элемент следующий за 4, то есть 4(ТУПО КАК ТО!).

    //Uint8List_from_Copy - буффер из которого копируются данные.
    //Четвертый параметр - это индекс элемента в буффере "Uint8List_from_Copy" с которого будут скопированы данные в размере "значение второго параметра минус значение первого парметра".
    //-----------------------------------------------------------------------------

    Uint8List_to_Copy.setRange(index_to_Copy, index_to_Copy + size_copy, Uint8List_from_Copy, index_from_Copy);
  }

  bool memcmp(Uint8List Uint8List_compare_1, int index_cmp_1, Uint8List Uint8List_compare_2, index_cmp_2, int num)
  {
    //index_cmp_1            - Индекс элемента в буффере "_Uint8List_ref" с которого нужно сранвить данные с данными из буффера "Uint8List_compare_2".
    //Uint8List_from_Copy    - Буффер "Uint8List" с которым нужно сранвить данные.
    //index_from_Copy        - индекс элемента из буффера "Uint8List_compare_2" откуда нужно сравнить данные.

    for(int i = 0; i < num; i++ )
    {
      if(Uint8List_compare_1[index_cmp_1 + i] != Uint8List_compare_2[index_cmp_2 + i])
      {
        return false;
      }

    }

    return true;
  }

  int get__element_value(int index)
  {
    return _Uint8List_ref![index];
  }

  int size()
  {
    return _size;
  }

  void reserve(int value_reserve)
  {
    if (value_reserve > _capacity_size)
    {
      _new_alloc__With_Copy(value_reserve, 0);
    }

  }

  int capacity()
  {
    return _capacity_size;
  }

  void resize(int new_size)
  {

    //--------------------------------------------------
    if(new_size > _capacity_size)
    {
      _new_alloc__With_Copy(new_size, 0);
    }
    //--------------------------------------------------

    _size = new_size;
  }

  void shrink_to_fit()
  {

    if(_capacity_size > _size)
    {
      _new_alloc__With_Copy(_size, 0);       //Сокращаем _capacity_size до _size.
    }

  }

  void clear()
  {
    _size           = 0;
    _capacity_size  = 0;
  }

  void free()
  {
    clear();

    _Uint8List_ref = null;

    initialization();
  }

  Uint8List get__Native_Uint8List_ref()
  {
    return _Uint8List_ref!;
  }

  int find_substring(int index_begin, int index_end, Uint8List substr, int substr_size)
  {
    //Простой поиск.

    int length = index_end - index_begin + 1;

    if (length < substr_size)
    {
      //Значит искомая подстрока больше, чем искомыый диапазон.

      return -1;
    }
    else
    {
      //Значит искомая подстрока равна или меньше диапазона в котором нужно искать. Расчитаем кол-во итераций, которое нужно будет пройти memcmp для поиска подстроки в указанном диапазоне:

      int num_iteration = (length - substr_size) + 1;

      //----------------------------------------------------------------------------------------
      for (int i = 0; i < num_iteration; i++)
      {
        // memcmp(int index_cmp_1, Uint8List Uint8List_which_to_compare, index_cmp_2, int num)

        bool res = memcmp(_Uint8List_ref!, index_begin + i, substr, 0, substr_size);

        if (res == true)
        {
          return index_begin + i;     //Значит подстрока совпадает с блоком памяти, значит нашли подстроку.
        }
      }
      //----------------------------------------------------------------------------------------

      //Если код дошел до сюда, значит совпадение найти не удалось.

      return -1;

    }

  }

  bool find_substring_to_List(int index_begin, int index_end, Uint8List substr, int substr_size, List<int> vector_result_ref)
  {

    bool found_flag = false;

    int index_begin_ = index_begin;


    for(;;)
    {

      //-----------------------------------------------------------------------------------------
      int res = find_substring(index_begin_, index_end, substr, substr_size);

      if(res > -1)
      {
        //Значит найдена "подстрока". res - это индекс элемента с которого она начинается.

        //--------------------------------------------------------------
        vector_result_ref.add(res);  //Занесем ее в вектор.

        found_flag = true;           //Ставим флаг, что хотя бы одна "подстрока" найдена.
        //--------------------------------------------------------------

        //--------------------------------------------------------------
        index_begin_ = res + substr_size;  //Смещаем начало диапазона поиска для следующео поиска "подстроки".
        //--------------------------------------------------------------
      }
      else
      {
        return found_flag;
      }
      //-----------------------------------------------------------------------------------------

    }

  }


  String? decode_to_String()
  {
    try
    {
      Uint8List Uint8List_view = Uint8List.view(_Uint8List_ref!.buffer, 0, _size);

      return utf8.decode(Uint8List_view);
    } on FormatException
    {
      return null;
    }

  }

  void print_only_WorkSize()
  {
    Uint8List Uint8List_temp = Uint8List.view(_Uint8List_ref!.buffer, 0, _size);

    print(Uint8List_temp);
  }

//----------------------------------------------Public:End--------------------------------------------------------------



  //----------------------------------------------Private:Begin-------------------------------------------------------------
  Float32List get__View_Type_Float32List(int Index_element, element_size)
  {
    return Float32List.view(_Uint8List_ref!.buffer, Index_element * Float32List.bytesPerElement, element_size);
  }
  Float64List get__View_Type_Float64List(int Index_element, element_size)
  {
    return Float64List.view(_Uint8List_ref!.buffer, Index_element * Float64List.bytesPerElement, element_size);
  }
  Int8List get__View_Type_Int8List(int Index_element, element_size)
  {
    return Int8List.view(_Uint8List_ref!.buffer, Index_element * Int8List.bytesPerElement, element_size);
  }
  Int16List get__View_Type_Int16List(int Index_element, element_size)
  {
    return Int16List.view(_Uint8List_ref!.buffer, Index_element * Int16List.bytesPerElement, element_size);
  }
  Int32List get__View_Type_Int32List(int Index_element, element_size)
  {
    return Int32List.view(_Uint8List_ref!.buffer, Index_element * Int32List.bytesPerElement, element_size);
  }
  Int64List get__View_Type_Int64List(int Index_element, element_size)
  {
    return Int64List.view(_Uint8List_ref!.buffer, Index_element * Int64List.bytesPerElement, element_size);
  }
  Uint8List get__View_Type_Uint8List(int Index_element, element_size)
  {
    return Uint8List.view(_Uint8List_ref!.buffer, Index_element * Uint8List.bytesPerElement, element_size);
  }
  Uint16List get__View_Type_Uint16List(int Index_element, element_size)
  {
    return Uint16List.view(_Uint8List_ref!.buffer, Index_element * Uint16List.bytesPerElement, element_size);
  }
  Uint32List get__View_Type_Uint32List(int Index_element, element_size)
  {
    return Uint32List.view(_Uint8List_ref!.buffer, Index_element * Uint32List.bytesPerElement, element_size);
  }
  Uint64List get__View_Type_Uint64List(int Index_element, element_size)
  {
    return Uint64List.view(_Uint8List_ref!.buffer, Index_element * Uint64List.bytesPerElement, element_size);
  }
  //----------------------------------------------Public:End--------------------------------------------------------------




//----------------------------------------------Private:Begin-------------------------------------------------------------
  Uint8List? _Uint8List_ref;
//----------------------------------------------Private:End--------------------------------------------------------------


//----------------------------------------------Private:Begin-------------------------------------------------------------
  int _size             = 0;
  int _capacity_size    = 0;         //Это общая выделнная память "_Uint8List_ref" включая рабочие элементы размером "_size".
  double _reserve_koef  = 0.4;       //Во сколько раз от рабочего размера - будет дополнительно резервироватся память.
//----------------------------------------------Private:End--------------------------------------------------------------


//----------------------------------------------Private:Begin-------------------------------------------------------------

  void _new_alloc__With_Copy(int alloc_size, double reserve_koef)
  {

    //------------------------------------------------------
    int new_size               = (alloc_size + (alloc_size)*reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);

    memcpy(Uint8List_new, 0, _Uint8List_ref!, 0, _size);           //Перекопируем существущие элементы в новый буффер.
    //------------------------------------------------------

    //------------------------------------------------------
    _capacity_size  = new_size;

    _Uint8List_ref = Uint8List_new;                        //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //------------------------------------------------------

  }
  Uint8List _new_alloc__Without_Copy(int alloc_size, double reserve_koef)
  {

    //------------------------------------------------------
    int new_size               = (alloc_size + (alloc_size)*reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);
    //------------------------------------------------------

    //------------------------------------------------------
    _capacity_size  = new_size;
    //------------------------------------------------------


    return Uint8List_new;
  }


  void _insert_After_with_NewAlloc(int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size)
  {

    //-------------------Выделяем новую память:begin-----------------------------------
    int alloc_size             = _size + insert_size;

    int new_size               = (alloc_size + (alloc_size)*_reserve_koef).toInt();

    Uint8List Uint8List_new    = Uint8List(new_size);
    //-------------------Выделяем новую память:end-----------------------------------



    //-------------------------------------------------------------------------------
    memcpy(Uint8List_new, 0, _Uint8List_ref!, 0, Index_element_to_Insert);                                                                                                    //Копируем ту часть текущих данных, которая находится до указанного эkемента "Index_element_to_Insert" ДО которого нужно вставить новые данные, НЕ ВКЛЮЧАЯ сам элемент "Index_element_to_Insert"
    memcpy(Uint8List_new, Index_element_to_Insert, Uint8List_insert, 0, insert_size);                                                                             //Теперь копируем те данные, которые нужно вставить.
    memcpy(Uint8List_new, Index_element_to_Insert + insert_size, _Uint8List_ref!, Index_element_to_Insert, _size - Index_element_to_Insert);     //И копируем оставшуюся текущую часть данных из "_Uint8List_ref" после новых вставленных данных.

    _Uint8List_ref = Uint8List_new;    //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //-------------------------------------------------------------------------------


    //------------------------------------------------------
    _capacity_size  = new_size;

    _Uint8List_ref = Uint8List_new;                        //Так память на которую раньше указывал "_Uint8List_ref" - теоретически должен подчистить сборщик мусора.
    //------------------------------------------------------




  }

  void _insert_Before_with_NewBuffer(Uint8List Uint8List_NewBuffer, Uint8List Current_Buffer, int Current_Buffer_size, int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size)
  {

    //Uint8List_NewBuffer - это буффер с уже необходимой выделенной памятю, но полностью пустой всмысле рабочих данных.

    memcpy(Uint8List_NewBuffer, 0, Current_Buffer, 0, Index_element_to_Insert);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert, Uint8List_insert, 0, insert_size);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + insert_size, Current_Buffer, Index_element_to_Insert, (Current_Buffer_size - Index_element_to_Insert) );

  }
  void _insert_Before_with_CurrentBuffer(Uint8List Buffer_into_which_insert, int Buffer_into_which_insert_size, int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size)
  {
    memcpy(Buffer_into_which_insert, (Index_element_to_Insert + insert_size), Buffer_into_which_insert, Index_element_to_Insert, (Buffer_into_which_insert_size - Index_element_to_Insert));

    memcpy(Buffer_into_which_insert, Index_element_to_Insert, Uint8List_insert, 0, insert_size);
  }
  void _insert_After_with_NewBuffer(Uint8List Uint8List_NewBuffer, Uint8List Current_Buffer, int Current_Buffer_size, int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size)
  {
    //Uint8List_NewBuffer - это буффер с уже необходимой выделенной памятю, но полностью пустой всмысле рабочих данных.

    memcpy(Uint8List_NewBuffer, 0, Current_Buffer, 0, Index_element_to_Insert + 1);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + 1, Uint8List_insert, 0, insert_size);

    memcpy(Uint8List_NewBuffer, Index_element_to_Insert + 1 + insert_size, Current_Buffer, (Index_element_to_Insert+1), (Current_Buffer_size - (Index_element_to_Insert+1)) );
  }
  void _insert_After_with_CurrentBuffer(Uint8List Buffer_into_which_insert, int Buffer_into_which_insert_size, int Index_element_to_Insert, Uint8List Uint8List_insert, int insert_size)
  {
    memcpy(Buffer_into_which_insert, (Index_element_to_Insert + insert_size + 1), Buffer_into_which_insert, (Index_element_to_Insert + insert_size), (Buffer_into_which_insert_size - (Index_element_to_Insert+1)));                                                                                                              //Копируем ту часть текущих данных, которая находится до указанного элемента "Index_element_to_Insert" после которого нужно вставить новые данные.

    memcpy(Buffer_into_which_insert, Index_element_to_Insert + 1, Uint8List_insert, 0, insert_size);
  }

  void _push_front__CurrentBuffer(Uint8List Buffer_into_which_push, int Buffer_into_which_push_size, Uint8List Uint8List_insert, int push_size)
  {
    memcpy(Buffer_into_which_push, push_size, Buffer_into_which_push, 0, Buffer_into_which_push_size);            //Копируем сначала данные из "CurrentBuffer" - как бы сдвигая их Вправо на размер вставляемых данных из "Uint8List_insert"

    memcpy(Buffer_into_which_push, 0, Uint8List_insert, 0, push_size);                                           //И Потом копируем сами вставляемые данные в начало буффера.
  }
  void _push_back__CurrentBuffer(Uint8List Buffer_into_which_push, int Buffer_into_which_push_size, Uint8List Uint8List_add, int push_size)
  {
    memcpy(Buffer_into_which_push, Buffer_into_which_push_size, Uint8List_add, 0, push_size);
  }


//----------------------------------------------Private:End-------------------------------------------------------------

}
//***********************************

//***********************************
void memcpy(Uint8List Uint8List_to_Copy, final int index_to_Copy, final Uint8List Uint8List_from_Copy, final int index_from_Copy, final int size_copy)
{
  //Uint8List_to_Copy       - Буффер куда нужно копировать данные из "Uint8List_from_Copy"
  //index_to_Copy           - Индекс элемента в буффере "Uint8List_to_Copy" куда нужно скопировать даныне из буффера "Uint8List_from_Copy".
  //Uint8List_from_Copy     - Буффер "Uint8List" откуда нужно скопировать данные.
  //index_from_Copy         - индекс элемента из буффера "index_from_Copy" откуда нужно скопировать элементы в размере "size_copy".


  //-----------------------------------------------------------------------------
  //Первый параметр: это Индекс элемента в буффере "Uint8List_to_Copy" с которого нужно начать вставлять данные из "Uint8List_from_Copy";
  //Второй параметр: это индекс элемента в буффере "Uint8List_to_Copy" ДО которого [НЕ Включая] нужно скпировать элементы из "Uint8List_from_Copy".
  //ТО ЕСТЬ - если нужно к примеру скоировать данные в буффер "Uint8List_to_Copy" со 2 элемента по 4 - то есть три элемента: 2,3,4 - то нужно указать: первым парметром - 1, а вторым парметром элемент следующий за 4, то есть 4(ТУПО КАК ТО!).

  //Uint8List_from_Copy - буффер из которого копируются данные.
  //Четвертый параметр - это индекс элемента в буффере "Uint8List_from_Copy" с которого будут скопированы данные в размере "значение второго параметра минус значение первого парметра".
  //-----------------------------------------------------------------------------

  Uint8List_to_Copy.setRange(index_to_Copy, index_to_Copy + size_copy, Uint8List_from_Copy, index_from_Copy);
}
bool memcmp(final Uint8List Uint8List_compare_1, final int index_cmp_1, final Uint8List Uint8List_compare_2, final int index_cmp_2, final int num)
{
  //index_cmp_1            - Индекс элемента в буффере "_Uint8List_ref" с которого нужно сранвить данные с данными из буффера "Uint8List_compare_2".
  //Uint8List_from_Copy    - Буффер "Uint8List" с которым нужно сранвить данные.
  //index_from_Copy        - индекс элемента из буффера "Uint8List_compare_2" откуда нужно сравнить данные.

  for(int i = 0; i < num; i++ )
  {
    if(Uint8List_compare_1[index_cmp_1 + i] != Uint8List_compare_2[index_cmp_2 + i])
    {
      return false;
    }

  }

  return true;
}
int find_substring(final Uint8List Buffer, final int index_begin, final int index_end, final Uint8List substr, final int substr_size)
{
  //Простой поиск.

  int length = index_end - index_begin + 1;

  if (length < substr_size)
  {
    //Значит искомая подстрока больше, чем искомыый диапазон.

    return -1;
  }
  else
  {
    //Значит искомая подстрока равна или меньше диапазона в котором нужно искать. Расчитаем кол-во итераций, которое нужно будет пройти memcmp для поиска подстроки в указанном диапазоне:

    int num_iteration = (length - substr_size) + 1;

    //----------------------------------------------------------------------------------------
    for (int i = 0; i < num_iteration; i++)
    {
      // memcmp(int index_cmp_1, Uint8List Uint8List_which_to_compare, index_cmp_2, int num)

      bool res = memcmp(Buffer, index_begin + i, substr, 0, substr_size);

      if (res == true)
      {
        return index_begin + i;     //Значит подстрока совпадает с блоком памяти, значит нашли подстроку.
      }
    }
    //----------------------------------------------------------------------------------------

    //Если код дошел до сюда, значит совпадение найти не удалось.

    return -1;

  }

}

class result_struct
{
  int split_range_p    = -1; //Указатель на первый левый символ найденной подстроки.
  int split_range_size = -1; //Размер подстроки начиная с left_p

  result_struct(this.split_range_p, this.split_range_size);
}
class request_struct
{
  late Uint8List pointer_to_subsrt;
  late int subsrt_size;

  request_struct(this.pointer_to_subsrt, this.subsrt_size);
}
class Get_Split_PointerRanges__class
{

//---------------------------------------------------------public:Begin-----------------------------------------------------------------------------------
  int get_vector_pointer__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result)
  {
    //---------------------------------------------------------------
    int offset = 0;
    //---------------------------------------------------------------
    int save_size = vector_for_result.length;
    //---------------------------------------------------------------
    int pointer_find_prev = 0;
    //---------------------------------------------------------------


//---------------------------------------------------------------
    for (;;)
    {
      final int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

      if (pointer_find == -1)
      {
        FinishRecording_BackTail(vector_for_result, offset, pointer_end, request_struct_, pointer_find_prev); //Записываем послдений задний "хвост", то есть то, что осталось после найденой послденей подстроки до конца строки.

        return vector_for_result.length - save_size;
      }
      else
      {
        //Значит нашли подстроку:


        //------------------------------------------------------------------
        if (offset == 0)
        {
          //Значит это первая найденная последотвалеьность:

          if (pointer_beg != pointer_find)
          {
            //Значит первый символ не совпадает с первым символом найденой подстроки и значит,что ДО найденной полстроки есть диапазон:

            vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg));
          }
        }
        else
        {
          //Значит это минимум вторая найденная последотвалеьность:

          final int split_range_p = (pointer_find_prev + request_struct_.subsrt_size); //Указатель на начало диапазона перед найденой подстрокой "pointer_find"

          if (split_range_p != pointer_find)
          {
            vector_for_result.add(new result_struct(split_range_p, pointer_find - split_range_p));
          }
          //------------------------------------------------------------------

        }


        pointer_find_prev = pointer_find;


        //--------------------------------------------------------------------------
        if ((pointer_find + request_struct_.subsrt_size) > pointer_end)
        {
          //Значит вышли за границы строки: Значит сразу после найденной Правой огарничивающей подстроки - ничего нет.

          return vector_for_result.length - save_size;
        }
        else
        {
          offset = (pointer_find + request_struct_.subsrt_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
        }
        //--------------------------------------------------------------------------

      }
    }
  }

  int get_vector_string__EndPointer(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<Uint8List?> vector_for_result)
  {
    //-----------------------------------------------------------------------------------------------------------------
    List<result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__EndPointer(Buffer, pointer_beg, pointer_end, request_struct_, vector_for_result_pointer);

    if (result < 1)
    {
      return result;
    }
    //-----------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------
    final int save_size = vector_for_result.length;

    vector_for_result.length = save_size + vector_for_result_pointer.length;

    for (int i = 0; i < vector_for_result_pointer.length; i++)
    {
      vector_for_result[save_size + i] = Uint8List(vector_for_result_pointer[i].split_range_size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].split_range_p, vector_for_result_pointer[i].split_range_size);
    }


    return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

  }

  int get_vector_pointer__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List<result_struct> vector_for_result, int Limit_Counter) {
//---------------------------------------------------------------
    int offset = 0;
//---------------------------------------------------------------
    int save_size = vector_for_result.length;
//---------------------------------------------------------------
    int pointer_find_prev = 0;
//---------------------------------------------------------------
    int Limit_Counter_inner = 0;
//---------------------------------------------------------------


//---------------------------------------------------------------
    for (;;)
    {
      final int pointer_find = find_substring(Buffer, pointer_beg + offset, pointer_end, request_struct_.pointer_to_subsrt, request_struct_.subsrt_size);

      if (pointer_find == -1)
      {
        if (Limit_Counter_inner < Limit_Counter)
        {
          FinishRecording_BackTail(vector_for_result, offset, pointer_end, request_struct_, pointer_find_prev); //Записываем послдений задний "хвост", то есть то, что осталось после найденой послденей подстроки до конца строки.
        }

        return vector_for_result.length - save_size;
      }
      else
      {
//Значит нашли подстроку:


//------------------------------------------------------------------
        if (offset == 0)
        {
//Значит это первая найденная последотвалеьность:

          if (pointer_beg != pointer_find)
          {
//Значит первый символ не совпадает с первым символом найденой подстроки и значит,что ДО найденной полстроки есть диапазон:

            if (Limit_Counter_inner < Limit_Counter)
            {
              vector_for_result.add(new result_struct(pointer_beg, pointer_find - pointer_beg));

              Limit_Counter_inner++;
            }
            else
            {
              return vector_for_result.length - save_size;
            }
          }
        }
        else
        {
//Значит это минимум вторая найденная последотвалеьность:

          final int split_range_p = (pointer_find_prev + request_struct_.subsrt_size); //Указатель на начало диапазона перед найденой подстрокой "pointer_find"

          if (split_range_p != pointer_find)
          {
            if (Limit_Counter_inner < Limit_Counter)
            {
              vector_for_result.add(new result_struct(split_range_p, pointer_find - split_range_p));

              Limit_Counter_inner++;
            }
            else
            {
              return vector_for_result.length - save_size;
            }
          }
        }
//------------------------------------------------------------------


        pointer_find_prev = pointer_find;


        //--------------------------------------------------------------------------
        if ((pointer_find + request_struct_.subsrt_size) > pointer_end)
        {
          //Значит вышли за границы строки: Значит сразу после найденной Правой огарничивающей подстроки - ничего нет.

          return vector_for_result.length - save_size;
        }
        else
        {
          offset = (pointer_find + request_struct_.subsrt_size) - pointer_beg; //Смещение относительно первого байта, с которого нужно начать новый цикл поиска.
        }
        //--------------------------------------------------------------------------


      }
    }
  }

  int get_vector_string__Limit_Counter(final Uint8List Buffer, final int pointer_beg, final int pointer_end, final request_struct request_struct_, List <Uint8List?> vector_for_result, int Limit_Counter)
  {
//-----------------------------------------------------------------------------------------------------------------
    List <result_struct> vector_for_result_pointer = [];

    final int result = get_vector_pointer__Limit_Counter(Buffer, pointer_beg, pointer_end, request_struct_, vector_for_result_pointer, Limit_Counter);

    if (result < 1)
    {
      return result;
    }
//-----------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------
    final int save_size = vector_for_result.length;

    vector_for_result.length = save_size + vector_for_result_pointer.length;

    for (int i = 0; i < vector_for_result_pointer.length; i++)
    {
      vector_for_result[save_size + i] = Uint8List(vector_for_result_pointer[i].split_range_size);

      memcpy(vector_for_result[save_size + i]!, 0, Buffer, vector_for_result_pointer[i].split_range_p, vector_for_result_pointer[i].split_range_size);
    }


    return vector_for_result.length - save_size;
//-----------------------------------------------------------------------------------------------------------------

  }
//---------------------------------------------------------public:End-----------------------------------------------------------------------------------


//---------------------------------------------------------public:End-----------------------------------------------------------------------------------


  //-----------------------------------------------------------private:Begin-----------------------------------------------------------------------------------
  void FinishRecording_BackTail(List<result_struct> vector_for_result, final int offset, final int pointer_end, final request_struct request_struct_, final int pointer_find_prev)
  {
    //-------------------------Дозаписываем задний хвост:начало-------------------
    if (offset != 0)
    {
      //Значит минимум одна последовтаельность уже была найдена и после нее до окнца строки остался "задний хвост", занесем его.

      vector_for_result.add(new result_struct((pointer_find_prev + request_struct_.subsrt_size), pointer_end - (pointer_find_prev + request_struct_.subsrt_size) + 1));
    }
    //-------------------------Дозаписываем задний хвост:конец-------------------

  }
//-----------------------------------------------------------private:End-----------------------------------------------------------------------------------


}
//***********************************




enum read_flag
    {
  Original_chunk,
  Accumulate_buffer,
  Read_untill,
}

class Socket_Struct
{

  Socket_Struct()
  {

  }


  //---------------------------------------------------------------Private:---------------------------------------------------------------------


  //--------------------------------------------------------
  Socket? _socket;

  late STD_LIST_Iterator<Socket_Struct> _socket_it;
  //--------------------------------------------------------


  //----------------------------------------------Struct_for_Read:Begin------------------------------------------------------------
  late StreamSubscription<Uint8List>? _Read__StreamSubscription_for_Read;      //Обьект который возвращает метод "listen". Нужен для дальнейшего взаимодействия с "прослушивателем".


  //``````````````````````````````````````````````
  Uint8List__class _Read__ReadUntill = new Uint8List__class();
  //``````````````````````````````````````````````

  //``````````````````````````````````````````````
  Uint8List__class _Read__AccumulateBuffer = new Uint8List__class();
  //``````````````````````````````````````````````

  //----------------------------------------------Struct_for_Read:End--------------------------------------------------------------


  //------------------------------------
  bool _connect_flag = false;
  bool _socket_close = true;
//------------------------------------

}


class Acceptor_struct
{

  Acceptor_struct(TCP_Server__class TCP_Server__class__ref, String Acceptor_Name_, InternetAddress IP_type_, int num_port_)
  {
    _TCP_Server__class__ref = TCP_Server__class__ref;

    Acceptor_Name = Acceptor_Name_;

    _IP_type = IP_type_;

    _num_port = num_port_;
  }


  //-----------------------------------------------------------Public:----------------------------------------------------------
  
  
  //-----------------------------------------------------------------------------------------
  void start_acceptor(Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, bool Connection_flag)? user_func_Connect, Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct_ref, Uint8List data)? user_func_Read)
  {

    _StreamSubscription_Socket = _acceptor!.listen((Socket client_Socket)
    {

        //Значит пришло новое Входяшие соединение:

      _acceptor_close = false;

      Socket_Struct Socket_Struct_added = _add__NewSocket(client_Socket);    //Добавляем сокет в список сокетов данного акцептора

      //------------------------------------------
      Socket_Struct_added._connect_flag = true;
      Socket_Struct_added._socket_close = false;
      //------------------------------------------



      //------------------------Оповещаем Пользователя о новом соединении:----------------------------------------
      if(_User_Shared_lambda_for_ConnectionStatus != null)
      {
        _User_Shared_lambda_for_ConnectionStatus!(_TCP_Server__class__ref, this, Socket_Struct_added, true);
      }

      if(user_func_Connect != null)
      {
        user_func_Connect!(_TCP_Server__class__ref, this, Socket_Struct_added, true);
      }
      //-----------------------------------------------------------------------------------------------------------


      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Встаем на прослушку Сокета для Входящих данных:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      Socket_Struct_added._Read__StreamSubscription_for_Read = client_Socket.listen((Uint8List Incoming_data)
      {
        //Если вызывается данный колбек, то значит пришла очередная порция Входящих данных "Incoming_data".

        _Read_choose_param(Socket_Struct_added, Incoming_data, user_func_Read);    //Читаем Входные данные.
      },
          onDone: ()async
          {
            //Если вызывается данный колбек, то значит соединение разорвано: возможно удаленный сервер закрыл соединение или другая причина.

            //Вызовем закрытие сокета на всякий случай:

            await close_Socket(Socket_Struct_added, false, false);

              //--------------------------------------------------------------------
              if(_User_Shared_lambda_for_ConnectionStatus != null)
              {
                _User_Shared_lambda_for_ConnectionStatus!(_TCP_Server__class__ref, this, Socket_Struct_added, false);
              }

              if(user_func_Connect != null)
              {
                user_func_Connect(_TCP_Server__class__ref, this, Socket_Struct_added, false);
              }
              //--------------------------------------------------------------------

          },
          onError: (error)
          {
            //Если вызывается данный колбек, то значит произошла какая то ошибка.

            //------------------------------------------------------------
            _User_Shared_lambda_error(_TCP_Server__class__ref, this, Socket_Struct_added, error.toString());       //Оповещаем Пользователя об ошибке.

            destroy_Socket(Socket_Struct_added, true);     //Уничтожаем Сокет.
            //------------------------------------------------------------

          },
          cancelOnError: true //Если произошла ошибка, отменяем подписку.
      );
      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Встаем на прослушку Сокета для Входящих данных:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    },
      onDone: ()async
      {
        //Если вызывается данный колбек, то значит соединение разорвано: возможно удаленный сервер закрыл соединение или другая причина.

        //Вызовем закрытие сокета на всякий случай:

        await destroy_acceptor(false);           //Закрываем акцептор.

      },
      onError: (error)async
      {
        //Если вызывается данный колбек, то значит произошла какая то ошибка.

        await destroy_acceptor(false);         //Закрываем акцептор.

        //------------------------------------------------------------
        _User_Shared_lambda_error(_TCP_Server__class__ref, this, null, error.toString());       //Оповещаем Пользователя об ошибке.

        _TCP_Server__class__ref.LIST__Acceptor.erase(_acceptor_it);                             //Удаляем структуру акцептора из контейнеров.
        //------------------------------------------------------------

      },
        cancelOnError: true //Если произошла ошибка, отменяем подписку.
    );


  }

  Future<void> destroy_acceptor(bool flush_flag)async
  {

    if(_acceptor_close == false)
    {

      String? string_res = null;


      try
      {
        await _StreamSubscription_Socket.cancel();

        //-----------------------------------------------------------------------------------
        await destroy_AllSocket(true);
        //-----------------------------------------------------------------------------------


        await _acceptor!.close();

        //----------------------------------------------------------------
          _TCP_Server__class__ref.LIST__Acceptor.erase(_acceptor_it);          //Удаляем структуру акцептора из контейнеров.
        //----------------------------------------------------------------


      }
      catch(error)
      {
        _TCP_Server__class__ref.LIST__Acceptor.erase(_acceptor_it);    //Удаляем структуру акцептора из контейнеров.

        _User_Shared_lambda_error(_TCP_Server__class__ref, this, null, error.toString());             //Оповещаем Пользователя об ошибке.
      }

    }

    return null;

  }
  //-----------------------------------------------------------------------------------------


  //---------------------------------------------------------------------------------------------------------------------
  int get__Socket_List_Size()
  {
    return _STD_LIST__Socket_Struct.size();
  }
  //---------------------------------------------------------------------------------------------------------------------


  //-------------------------------------------------------------------------------------------------------------------
  Future<void> close_Socket(Socket_Struct? Socket_Struct_ref, bool flush_flag, bool erase_socket_flag)async
  {

    if(Socket_Struct_ref!._socket_close == false)
    {

      Socket_Struct_ref._socket_close = true;


      try
      {
        //----------------------------------------------------------------------------
        await Socket_Struct_ref._Read__StreamSubscription_for_Read!.cancel();

        if (flush_flag == true)
        {
          await Socket_Struct_ref._socket!.flush();
        }

        await Socket_Struct_ref._socket!.close();
        //----------------------------------------------------------------------------


        //----------------------------------------------------------------------------
        Socket_Struct_ref._connect_flag                      = false;
        Socket_Struct_ref._socket                            = null;
        Socket_Struct_ref._Read__StreamSubscription_for_Read = null;
        //----------------------------------------------------------------------------

        //----------------------------------------------------------------------------
        if (erase_socket_flag == true)
        {
          _STD_LIST__Socket_Struct.erase(Socket_Struct_ref._socket_it); //Удаляем структуру сокета из контейнеров.
        }
        //----------------------------------------------------------------------------

        return null;

      } catch (error)
      {
        //------------------------------------------------------------
        destroy_Socket(Socket_Struct_ref!, true);                        //Уничтожаем Сокет.
        //------------------------------------------------------------

        _User_Shared_lambda_error(_TCP_Server__class__ref, this, null, error.toString());             //Оповещаем Пользователя об ошибке.
      }

    }

    return null;
  }

  Future<void> close_AllSocket(bool flush_flag, bool erase_socket_flag)async
  {

    List<STD_LIST_Iterator<Socket_Struct>>List_Iterator_Copy = [];

    //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "_STD_LIST__Socket_Struct" которые нужно удалить на момент вызова:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _STD_LIST__Socket_Struct.iterration_lopp(_STD_LIST__Socket_Struct.begin(), _STD_LIST__Socket_Struct.last(), (STD_LIST__class<Socket_Struct> class_ref, STD_LIST_Iterator<Socket_Struct> it)
    {
      List_Iterator_Copy.add(it);

      return true; //продолжаем итарацию.
    });
    //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "_STD_LIST__Socket_Struct" которые нужно удалить на момент вызова:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



    //------------------------------------------------------------
    String? string_res = null;

    for(int i = 0; i < List_Iterator_Copy.length; i++)
    {
      await close_Socket(List_Iterator_Copy[i].get__value(), flush_flag, erase_socket_flag);
    }
    //------------------------------------------------------------

  }

  Future<void> destroy_Socket(Socket_Struct? Socket_Struct_ref, bool erase_socket_flag)async
  {

    //-------------------------------------------------------------
    if(Socket_Struct_ref!._socket_close == false)
    {
      await Socket_Struct_ref!._Read__StreamSubscription_for_Read!.cancel();

      if(Socket_Struct_ref._socket != null)
      {
        Socket_Struct_ref._socket!.destroy();                            //destroy() - Полностью закрывает Сокет в синхрнном-блокируюем режиме и не ждет ни какой отправи данных, если он есть в буффере.

        Socket_Struct_ref._connect_flag = false;
        Socket_Struct_ref._socket_close = true;
        Socket_Struct_ref._socket       = null;
        Socket_Struct_ref!._Read__StreamSubscription_for_Read = null;
      }

    }
    //-------------------------------------------------------------


    //-------------------------------------------------------------
    if(erase_socket_flag == true)
    {
      _STD_LIST__Socket_Struct.erase(Socket_Struct_ref._socket_it);        //Удаляем структуру сокета из контейнеров.
    }
    //-------------------------------------------------------------


  }

  Future<void> destroy_AllSocket(bool erase_socket_flag) async
  {

    List<STD_LIST_Iterator<Socket_Struct>>List_Iterator_Copy = [];

    //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "_STD_LIST__Socket_Struct" которые нужно удалить на момент вызова:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _STD_LIST__Socket_Struct.iterration_lopp(_STD_LIST__Socket_Struct.begin(), _STD_LIST__Socket_Struct.last(), (STD_LIST__class<Socket_Struct> class_ref, STD_LIST_Iterator<Socket_Struct> it)
    {
      List_Iterator_Copy.add(it);

      return true; //продолжаем итарацию.
    });
    //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "_STD_LIST__Socket_Struct" которые нужно удалить на момент вызова:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //------------------------------------------------------------
    String? string_res = null;

    for(int i = 0; i < List_Iterator_Copy.length; i++)
    {
      await destroy_Socket(List_Iterator_Copy[i].get__value(), erase_socket_flag);

    }
    //------------------------------------------------------------

  }
  //----------------------------------------------------------------------------------------------------------------------

  
  //---------------------------------------------------------------------------------------------------------------------
  void set__ReadParamFlag_for_Socket(read_flag ReadUntill_flag_)
  {
    _read_flag = ReadUntill_flag_;
  }

  void set__ReadUntill_Seperator_for_Socket(Uint8List Uint8List_Separator)
  {
    _Read__ReadUntill_seperator = Uint8List(Uint8List_Separator.length);   //Выделим память

    memcpy(_Read__ReadUntill_seperator, 0, Uint8List_Separator, 0, Uint8List_Separator.length);  //перекопируем Пользовательский разделитель.
  }

  void set__AccumulateBuffer_Size_for_Socket(int size)
  {
    _Read__Accumulate_size = size;
  }
  //---------------------------------------------------------------------------------------------------------------------


  //---------------------------------------------------------------------------------------------------------------------
  void send__Bytes_to_socket(Socket_Struct Socket_Struct__ref, Uint8List data, bool copy_data_flag)
  {

    //--------------------------------------------------------------------------
    Uint8List dataCopy;

    if(copy_data_flag == true)
    {
      dataCopy = Uint8List.fromList(data);   //Так как при передаче данных с помощью "add" - требуется, чтобы исходный буффер сохранялся и не изменялся на все время передачи, то, чтобы Пользователь не держал буффер сохранным сделаем его копию - хотя конечно - это дополнительные затарты на копирование.
    }
    else
    {
      //Значит Пользователю нужно держать буффер "data" полностью рабочим и неизменяемым, до передачи данных. Но есть проблема, как узнать, что данные уже отправлены, и буффер можно переиспользовать. А хрен знает, я так и не понял.

      dataCopy = data;  //Просто копирую ссылку на "data"
    }
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    try
    {
        Socket_Struct__ref._socket!.add(dataCopy); //Доабвляем задачу в очередь задач, на отправку данныx "dataCopy" через сокет.
    }
    catch(error, stacktrace)
    {
      _User_Shared_lambda_error(_TCP_Server__class__ref, this, Socket_Struct__ref, error.toString());

      destroy_Socket(Socket_Struct__ref, true);                         //Уничтожаем Сокет.
    }
    //--------------------------------------------------------------------------



  }
  //---------------------------------------------------------------------------------------------------------------------




  //---------------------------------------------------------------------Private:------------------------------------------------------------------------------

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  //-----------------------------------------------
  late TCP_Server__class _TCP_Server__class__ref;       //Ссылка на TCP_Server__class класс.
  //-----------------------------------------------
  late String Acceptor_Name;

  late ServerSocket? _acceptor;

  late STD_LIST_Iterator<Acceptor_struct> _acceptor_it;

  late InternetAddress _IP_type;

  late int _num_port;
  //-----------------------------------------------

  //-----------------------------------------------
  late StreamSubscription<Socket> _StreamSubscription_Socket;
  bool _acceptor_close = true;
  //-----------------------------------------------

  //-----------------------------------------------
  late Uint8List _Read__ReadUntill_seperator;                      //Общий для всех Сокетов данного Акцептора.
  int _Read__Accumulate_size = 1024;   //по умолчанию.             //Общий для всех Сокетов данного Акцептора.

  read_flag _read_flag = read_flag.Original_chunk;   //Флаг того, как обрабатывать Входящие данные на Сокете.
  //Original_chunk     - Значит, что каждый Входящий буффер данных стразу будет отправлятся в Пользовательский колбек без каких либо дополнительных действий.
  //Accumulate_buffer  - Значит, что каждый Входящий буффер данных будет добовлятся в "_Read__AccumulateBuffer" буффер до указанного в "_Read__Accumulate_size" размера - при жостижении размера буффера >= "_Read__Accumulate_size" в колбек будет напарвлятся указатель на часть данных размером "_Read__Accumulate_size" и после колбека будет удалена.
  //Read_untill        - Значит, что каждый Входящий буффер данных будет добовлятся в "_Read__ReadUntill" до тех пор пока не будет найден заданный Пользователем "разделитель" после чего будет вызван Пользоватльеский колбек и после колбека данные до разделителя и сам разделитель будут удалены.

  //----------------------------------For ReadUntill:------------------------------------------------------------
  Get_Split_PointerRanges__class Get_Split_PointerRanges_    = new Get_Split_PointerRanges__class();
  request_struct request_struct_                             = new request_struct(Uint8List(0), 0);
  List<result_struct> vec_result_split_                      = [];
  //-------------------------------------------------------------------------------------------------------------

  //-----------------------------------------------

  STD_LIST__class<Socket_Struct> _STD_LIST__Socket_Struct = new STD_LIST__class();
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  //-------------------------------------------------------------------------------------------------------------------------------
  late Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, String text_error) _User_Shared_lambda_error;
  //-------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------
  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref)? _User_Shared_lambda_for_CloseAcceptor = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct_ref)? _User_Shared_lambda_for_CloseSocket = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, bool Connection_flag)? _User_Shared_lambda_for_ConnectionStatus = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct__ref, Uint8List data)? _User_Shared_lambda_for_Read = null;
 //-------------------------------------------------------------------------------------------------------------------------------


  //################################################################################################################################################################

  Future<void> _create_acceptor(InternetAddress IP_type, int num_port) async
  {
    _acceptor = await ServerSocket.bind(IP_type, num_port);
  }

  void _Read_choose_param(Socket_Struct Socket_Struct_, Uint8List Incoming_data, Function(TCP_Server__class TCP_Client__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct_ref, Uint8List data)? user_func_Read)
  {

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if(_read_flag == read_flag.Original_chunk)
    {
      //-----------------------------------------------------
      if(_User_Shared_lambda_for_Read != null)
      {
        _User_Shared_lambda_for_Read!(_TCP_Server__class__ref, this, Socket_Struct_, Incoming_data);    //Вызываем Пользовательский колбек.
      }

      if(user_func_Read != null)
      {
        user_func_Read(_TCP_Server__class__ref, this, Socket_Struct_, Incoming_data);
      }
      //-----------------------------------------------------
    }
    else
    {
      if(_read_flag == read_flag.Read_untill)
      {
        //Значит нужно накапливать данные до тех пор, пока не найдем Пользовательский разделитель:

        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Вычисляем начальный элемент во Входяем буффере с которого начнем поиск разделителя:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        //Так как буффер накапливаемый, то нет никакого смысла искать разделитель каждый раз с начала буффера. Каждый раз с приходом новой порции данных, искать разделитель нужно с конца текущего буффера минус длинна разделителя.

        int find_begin_index = (Socket_Struct_._Read__ReadUntill.size() - 1) - _Read__ReadUntill_seperator.length - 1;

        if (find_begin_index < 0)
        {
          find_begin_index = 0;
        }

        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Вычисляем начальный элемент во Входяем буффере с которого начнем поиск разделителя:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        Socket_Struct_._Read__ReadUntill.push_back(Incoming_data, Incoming_data.length); //Добавляем данные в Накапливаемый Буффер.


        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Ищем разделитель:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        request_struct_.pointer_to_subsrt = _Read__ReadUntill_seperator;
        request_struct_.subsrt_size       = _Read__ReadUntill_seperator.length;

        vec_result_split_.length = 0;
        final int result = Get_Split_PointerRanges_.get_vector_pointer__EndPointer(Socket_Struct_._Read__ReadUntill.get__Native_Uint8List_ref(), find_begin_index, Socket_Struct_._Read__ReadUntill.get__Native_Uint8List_ref().length - 1, request_struct_, vec_result_split_);

        if (result > 0)
        {
          //Значит разделитель найден. result - это кол-во найденных разделённых подстрок: 1234$56$789 - разделенные подстроки это "1234", "56", "789". "$" - соотвтвенно сам разделитель.
          //ВНИМАНИЕ: нам нужно отработать только первые "result - 1" Найденных подстрок. ТО ЕСТЬ к примеру разделитель это символ "$", сам буффер содержит такие данные: 1234$56$789 - то есть в буффере присутствует ДВА разделителя и ТРИ разделенные подстроки, ТРЕТЬЮ подстроку "789" мы не трогаем и Не сообщаем о ней Пользователю через колбек, так как для нее еще не пришел свой разделитель. Мы его оставляет в буффере для следящего накопления данных и поиска разделителя.

          for (int i = 0; i < vec_result_split_.length - 1; i++)
          {
            //vec_result_split_[i].split_range_p  - номер элемета в буффере "Socket_Struct_._Read__ReadUntill" который указывает на разделенных данные До разделителя. Сообщим оь этом Пользователю.

            Uint8List Uint8List_view = Socket_Struct_._Read__ReadUntill.get__View_Type_Uint8List(vec_result_split_[i].split_range_p, vec_result_split_[i].split_range_size); //Получаем указатель на часть данных, который идут перед разделителем, не включая сам разделитель.


            //````````````````````````````````````````````````````````````````````
            if (_User_Shared_lambda_for_Read != null)
            {
              _User_Shared_lambda_for_Read!(_TCP_Server__class__ref, this, Socket_Struct_, Uint8List_view); //Вызываем Пользовательский колбек.
            }

            if (user_func_Read != null)
            {
              user_func_Read(_TCP_Server__class__ref, this, Socket_Struct_, Uint8List_view);
            }
            //````````````````````````````````````````````````````````````````````

          }


          Socket_Struct_._Read__ReadUntill.erase_range(0, vec_result_split_.last.split_range_p - 1); //ТЕПЕРЬ Удалаяем все данные из Буффера вплоть до последнего разделитея в буффере.
        }

        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Ищем разделитель:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      }
      else
      {
        //Значит нужно накапливать данные до тех пор, пока буффер не достигнет определенного размера:

        Socket_Struct_._Read__AccumulateBuffer.push_back(Incoming_data, Incoming_data.length);        //Добавляем данные в Накапливаемый Буффер.

        if(Socket_Struct_._Read__AccumulateBuffer.size() >= _Read__Accumulate_size)
        {

          //````````````````````````````````````````````````````````````````````````````````
          int part_num = (Socket_Struct_._Read__AccumulateBuffer.size() / _Read__Accumulate_size).floor();   //Вычисляем число частей кратно "_Read__Accumulate_size" с округлением вниз, то есть сколько раз нужно вызвать колбек для оповещения Пользователя о частях "_Read__Accumulate_size" буффера.

          for(int i = 0; i < part_num; i++ )
          {

            //Значит берем указатель-view на часть в размере "_Read__Accumulate_size" и вызываем Пользовательский колбек:

            Uint8List Uint8List_view = Socket_Struct_._Read__AccumulateBuffer.get__View_Type_Uint8List((i*_Read__Accumulate_size), _Read__Accumulate_size); //Получаем указатель на часть данных


            //````````````````````````````````````````````````````````````````````
            if (_User_Shared_lambda_for_Read != null)
            {
              _User_Shared_lambda_for_Read!(_TCP_Server__class__ref, this, Socket_Struct_, Uint8List_view); //Вызываем Пользовательский колбек.
            }

            if (user_func_Read != null)
            {
              user_func_Read(_TCP_Server__class__ref, this, Socket_Struct_, Uint8List_view);
            }
            //````````````````````````````````````````````````````````````````````


          }
          //````````````````````````````````````````````````````````````````````````````````


          //````````````````````````````````Удаляем данные, о которых уже опощен Пользователь:````````````````````````````````````
          final tail_size = Socket_Struct_._Read__AccumulateBuffer.size() - part_num * _Read__Accumulate_size;    //Это размер буффера после того, как мы удалим данные с начала буффера в размере "_Read__Accumulate_size"

          memcpy(Socket_Struct_._Read__AccumulateBuffer.get__Native_Uint8List_ref(), 0, Socket_Struct_._Read__AccumulateBuffer.get__Native_Uint8List_ref(), _Read__Accumulate_size, tail_size);

          Socket_Struct_._Read__AccumulateBuffer.resize(tail_size);
          //``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

        }




      }

    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  }

  Socket_Struct _add__NewSocket(Socket client_Socket)
  {
    _STD_LIST__Socket_Struct.push_back(new Socket_Struct());
    _STD_LIST__Socket_Struct.last()!.get__value()._socket = client_Socket;
    _STD_LIST__Socket_Struct.last()!.get__value()._socket_it = _STD_LIST__Socket_Struct.last()!;

    return _STD_LIST__Socket_Struct.last()!.get__value();
  }
  
}





class TCP_Server__class
{


  TCP_Server__class(Function(TCP_Server__class TCP_Server__ref, Acceptor_struct? Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, String text_error) User_Shared_lambda_error_)
  {
    _User_Shared_lambda_error = User_Shared_lambda_error_;

    LIST__Acceptor = new STD_LIST__class();
  }


  //--------------------------------------------------------------------Public:--------------------------------------------------------------------------

  //----------------------------------------------------------------------------------------------
  Future<Acceptor_struct> add__NewAcceptor(String Acceptor_Name, InternetAddress IP_type, int num_port)async
  {

    //-------------------------------------------------------------------------------------
    LIST__Acceptor.push_back(new Acceptor_struct(this, Acceptor_Name, IP_type, num_port));

    await LIST__Acceptor.last()!.get__value()._create_acceptor(IP_type, num_port);
    //-------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------
    LIST__Acceptor.last()!.get__value()._User_Shared_lambda_error = _User_Shared_lambda_error;

    LIST__Acceptor.last()!.get__value()._User_Shared_lambda_for_ConnectionStatus = _User_Shared_lambda_for_ConnectionStatus;
    LIST__Acceptor.last()!.get__value()._User_Shared_lambda_for_Read             = _User_Shared_lambda_for_Read;
    LIST__Acceptor.last()!.get__value()._User_Shared_lambda_for_CloseSocket      = _User_Shared_lambda_for_CloseSocket;
    LIST__Acceptor.last()!.get__value()._User_Shared_lambda_for_CloseAcceptor    = _User_Shared_lambda_for_CloseAcceptor;
    //-------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------
    LIST__Acceptor.last()!.get__value()._acceptor_it = LIST__Acceptor.last()!;
    //-------------------------------------------------------------------------------------


    return LIST__Acceptor.last()!.get__value();
  }

  Acceptor_struct? get__Acceptor_by_Name(String Acceptor_Name)
  {

    STD_LIST_Iterator<Acceptor_struct>? it = null;

    //------------------------------------------------------------
    for(;;)
    {
      it = LIST__Acceptor.std_next_with_null(it);

      if (it == null)
      {
        break;
      }
      else
      {
        if (it.get__value().Acceptor_Name == Acceptor_Name)
        {
           return it.get__value();
        }
      }
    }
    //------------------------------------------------------------

    return null;

  }

  Future<String?> destroy_All_acceptor(bool flush_flag)async
  {


      //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "LIST__Acceptor" которые нужно удалить на момент вызова:Begin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      List<STD_LIST_Iterator<Acceptor_struct>>List_Iterator_for_CloseAllAcceptor = [];

      LIST__Acceptor.iterration_lopp(LIST__Acceptor.begin(), LIST__Acceptor.last(), (STD_LIST__class<Acceptor_struct> class_ref, STD_LIST_Iterator<Acceptor_struct> it)
      {
        List_Iterator_for_CloseAllAcceptor.add(it);

        return true; //продолжаем итарацию.
      });
      //~~~~~~~~~~~~~~~~~~~~~Скопируем итераторы из "LIST__Acceptor" которые нужно удалить на момент вызова:End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



      //-------------------------------------------------------------------------------------------
      for(int i = 0; i < List_Iterator_for_CloseAllAcceptor.length; i++)
      {
        await List_Iterator_for_CloseAllAcceptor[i].get__value().destroy_acceptor(flush_flag);
      }
      //-------------------------------------------------------------------------------------------

  }
  //----------------------------------------------------------------------------------------------




  //----------------------------------------------------------------------------------------------
  void set__Shared_Callback_for_SocketRead(Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, Uint8List data) User_Shared_lambda_for_Read_)
  {
    _User_Shared_lambda_for_Read = User_Shared_lambda_for_Read_;

    //------------------Передаем ссылку на колбек в структуру Ацепторов:------------------
    LIST__Acceptor.iterration_lopp(LIST__Acceptor.begin(), LIST__Acceptor.last(), (STD_LIST__class<Acceptor_struct> Acceptor_struct__ref, STD_LIST_Iterator<Acceptor_struct> it)
    {
      it.get__value()._User_Shared_lambda_for_Read = _User_Shared_lambda_for_Read;
      return true;
    });
    //------------------------------------
  }
  void set__Shared_Callback_for_Connect(Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, bool Connection_flag) User_Shared_lambda_for_ConnectionStatus_)
  {
    _User_Shared_lambda_for_ConnectionStatus = User_Shared_lambda_for_ConnectionStatus_;


    //------------------Передаем ссылку на колбек в структуру Ацепторов:------------------
    LIST__Acceptor.iterration_lopp(LIST__Acceptor.begin(), LIST__Acceptor.last(), (STD_LIST__class<Acceptor_struct> Acceptor_struct__ref, STD_LIST_Iterator<Acceptor_struct> it)
    {
      it.get__value()._User_Shared_lambda_for_ConnectionStatus = _User_Shared_lambda_for_ConnectionStatus;
      return true;
    });
    //------------------------------------

  }
  void set__Shared_Callback_for_CloseSocket(Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct_ref) User_Shared_lambda_for_CloseSocket_)
  {
    _User_Shared_lambda_for_CloseSocket = User_Shared_lambda_for_CloseSocket_;

    //------------------Передаем ссылку на колбек в структуру Ацепторов:------------------
    LIST__Acceptor.iterration_lopp(LIST__Acceptor.begin(), LIST__Acceptor.last(), (STD_LIST__class<Acceptor_struct> Acceptor_struct__ref, STD_LIST_Iterator<Acceptor_struct> it)
    {
      it.get__value()._User_Shared_lambda_for_CloseSocket = _User_Shared_lambda_for_CloseSocket;
      return true;
    });
    //------------------------------------
  }
  void set__Shared_Callback_for_CloseAcceptor(Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref) User_Shared_lambda_for_CloseAcceptor_)
  {
    _User_Shared_lambda_for_CloseAcceptor = User_Shared_lambda_for_CloseAcceptor_;

    //------------------Передаем ссылку на колбек в структуру Ацепторов:------------------
    LIST__Acceptor.iterration_lopp(LIST__Acceptor.begin(), LIST__Acceptor.last(), (STD_LIST__class<Acceptor_struct> Acceptor_struct__ref, STD_LIST_Iterator<Acceptor_struct> it)
    {
      it.get__value()._User_Shared_lambda_for_CloseAcceptor = _User_Shared_lambda_for_CloseAcceptor;
      return true;
    });
    //------------------------------------
  }
  //----------------------------------------------------------------------------------------------



  //--------------------------------------------------------------------Private:--------------------------------------------------------------------------


  //---------------------------------------------------------
  late STD_LIST__class<Acceptor_struct>LIST__Acceptor;
  //---------------------------------------------------------




  //-------------------------------------------------------------------------------------------------------------------------------
  late Function(TCP_Server__class TCP_Server__ref, Acceptor_struct? Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, String text_error) _User_Shared_lambda_error;
  //-------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------------------------------------
  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref)? _User_Shared_lambda_for_CloseAcceptor = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct_ref)? _User_Shared_lambda_for_CloseSocket = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct? Socket_Struct__ref, bool Connection_flag)? _User_Shared_lambda_for_ConnectionStatus = null;

  Function(TCP_Server__class TCP_Server__class__ref, Acceptor_struct Acceptor_struct__ref, Socket_Struct Socket_Struct__ref, Uint8List data)? _User_Shared_lambda_for_Read = null;
  //-------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------




}
