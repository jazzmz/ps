{pirsavelog.p}

{globals.i}

{setdest.i}

for each code where code.class = "СтатьиСметыРасх" and 
		    code.parent = "СтатьиСметыРасх" by code.code:
put unformatted code.code space
		code.name skip.
   for each sign where sign.code = code.class and
                       sign.xattr-value = code.code and
		       sign.file-name = "acct" by substring(sign.surrogate,1,20):
     put unformatted space(5) substring(sign.surrogate,1,20) skip.
   end.
		
end.


{preview.i}