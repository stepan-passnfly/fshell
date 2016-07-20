shell
======

**shell scripting framework.**  

**objetives:**
- write once and use much
- write less because less is a plus
- create script more readable
- think and write only a logic code in the new script 
- don't write redundant code into multiple script
- support *nix more common through their defaults shells with the same code.

Guidelines (google shell scripting gudelines compliant).
-------------
**functions**
<pre>
name_function ()
{
  ...
}
</pre>
**conditionals**
<pre>
if [ conditions ]; then
  ...
elif [ condition ]; then
  ...
else
  ...
fi
</pre>
in line conditions
<pre>
[[ $a -gt $b ]] && echo $a || echo $b
</pre>
compare integers
<pre>
-lt (<)
-gt (>)
-le (<=)
-ge (>=)
-eq (==)
-ne (!=)
</pre>
compare strings
<pre>
== (equal)
!= (distinct)
</pre>
**loops**
<pre>
for value in iterable; do
  ...
done
</pre>

<pre>
while [ conditions ]; do
  ...
done

</pre>
**calls**

to execute commands or string functions use:
- good:
<pre>
$(called_cmd)
</pre>
- wrong:
<pre>
\`called_cmd\`
</pre> 
not use `` because $() is more redeable 

**comments mandatory before function implementation**
<pre>
#/ name:
#/ usage:
#/ desc:
#/ usage as:
#/ params:
#/ return:
</pre>
