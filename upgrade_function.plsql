CREATE OR REPLACE FUNCTION pg_temp.BT(i TEXT,  sep TEXT default '-') 
-- get a sequence of numeric values and returns a list classifying then as upgrade, new, downgrade and true
RETURNS text AS '
declare
  	list decimal array[10] := regexp_split_to_array(i, sep);
    sequence text array[10];
    status varchar(8);
    num numeric := array_length(list,1);
    var int;
    aux int;
  BEGIN
  foreach var in array list
   LOOP 
	  if (var>aux) then
      sequence := array_append(sequence, ($$upgrade$$)::text);
      elsif (var<aux) then
	  sequence := array_append(sequence, ($$downgrade$$)::text);
      elsif (var=aux) then 
      sequence :=  array_append(sequence, ($$neutral$$)); 
      else
	  null; 
      end if;
      aux = var::text;
   END LOOP;
    RETURN sequence;
  END
' LANGUAGE PLPGSQL IMMUTABLE;
