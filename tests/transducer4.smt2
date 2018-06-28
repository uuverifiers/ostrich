(set-logic QF_S)

; ----------------
; htmlEscape
; -----------------
; https://github.com/google/closure-library/blob/master/closure/goog/string/string.js#L587
; "&"  = &amp;
; "<"  = &lt;
; ">"  = &gt;
; """  = &quot;
; "'"  = &#39;
; "e"  = &#101; ???
; \x00 = &#0;

(define-funs-rec ((htmlEscape  ((x String) (y String)) Bool)
                  (he1  ((x String) (y String)) Bool)
                  (he2  ((x String) (y String)) Bool)
                  (he3  ((x String) (y String)) Bool)
                  (he4  ((x String) (y String)) Bool)
                  (he5  ((x String) (y String)) Bool)
                  (he6  ((x String) (y String)) Bool)
                  (he7  ((x String) (y String)) Bool)
                  (he8  ((x String) (y String)) Bool)
                  (he9  ((x String) (y String)) Bool)
                  (he10 ((x String) (y String)) Bool)
                  (he11 ((x String) (y String)) Bool)
                  (he12 ((x String) (y String)) Bool)
                  (he13 ((x String) (y String)) Bool)
                  (he14 ((x String) (y String)) Bool)
                  (he15 ((x String) (y String)) Bool)
                  (he16 ((x String) (y String)) Bool)
                  (he17 ((x String) (y String)) Bool)) (

                  ; definition of htmlEscape
                  (or (and (= (seq-head x) (_ bv38 8)) ; '&'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (he1 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv60 8)) ; '<'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (he2 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv62 8)) ; '>'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (he3 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv34 8)) ; '\"'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (he4 (seq-tail x) (seq-tail y)))
                      (and (and (or (= (seq-head x) (_ bv39  8))   ; '\''
                                    (= (seq-head x) (_ bv101 8))   ; 'e'
                                    (= (seq-head x) (_ bv92  8)))  ; '\\'
                                (= (seq-head y) (_ bv38 8))        ; '&'
                           (he5 (seq-tail x) (seq-tail y))))
					            (and (= (seq-head x) (seq-head y))           ; x <=> y
                           (or (not (= (seq-head x) (_ bv39  8)))  ; '\''
                               (not (= (seq-head x) (_ bv38  8)))  ; '&'
                               (not (= (seq-head x) (_ bv60  8)))  ; '<'
                               (not (= (seq-head x) (_ bv62  8)))  ; '>'
                               (not (= (seq-head x) (_ bv34  8)))  ; '\"'
                               (not (= (seq-head x) (_ bv92  8)))  ; '\\'
                               (not (= (seq-head x) (_ bv101 8)))) ; 'e'
                           (htmlEscape (seq-tail x) (seq-tail y))))

                  ; definition of he1
                  (or (and (= (seq-head y) (_ bv97 8))  ; 'a'
                           (he6 x (seq-tail y))))

                  ; definition of he2
                  (or (and (= (seq-head y) (_ bv108 8)) ; 'l'
                           (he13 x (seq-tail y))))

                  ; definition of he3
                  (or (and (= (seq-head y) (_ bv103 8)) ; 'g'
                           (he13 x (seq-tail y))))

                  ; definition of he4
                  (or (and (= (seq-head y) (_ bv113 8)) ; 'q'
                           (he7 x (seq-tail y))))

                  ; definition of he5
                  (or (and (= (seq-head y) (_ bv35 8))  ; '#'
                           (he8 x (seq-tail y))))

                  ; definition of he6
                  (or (and (= (seq-head y) (_ bv109 8)) ; 'm'
                           (he9 x (seq-tail y))))

                  ; definition of he7
                  (or (and (= (seq-head y) (_ bv117 8)) ; 'u'
                           (he10 x (seq-tail y))))

                  ; definition of he8
                  (or (and (= (seq-head y) (_ bv51 8))  ; '3'
                           (he11 x (seq-tail y)))
                      (and (= (seq-head y) (_ bv49 8))  ; '1'
                           (he12 x (seq-tail y)))
                      (and (= (seq-head y) (_ bv48 8))  ; '0'
                           (he15 x (seq-tail y))))

                  ; definition of he9
                  (or (and (= (seq-head y) (_ bv112 8)) ; 'p'
                           (he15 x (seq-tail y))))

                  ; definition of he10
                  (or (and (= (seq-head y) (_ bv111 8)) ; 'o'
                           (he13 x (seq-tail y))))

                  ; definition of he11
                  (or (and (= (seq-head y) (_ bv57 8))  ; '9'
                           (he15 x (seq-tail y))))

                  ; definition of he12
                  (or (and (= (seq-head y) (_ bv48 8))  ; '0'
                           (he14 x (seq-tail y))))

                  ; definition of he13
                  (or (and (= (seq-head y) (_ bv116 8)) ; 't'
                           (he15 x (seq-tail y))))

                  ; definition of he14
                  (or (and (= (seq-head y) (_ bv49 8))  ; '1'
                           (he15 x (seq-tail y))))

                  ; definition of he15
                  (or (and (= (seq-head y) (_ bv59 8))  ; ';'
                           (he16 x (seq-tail y))))

                  ; definition of he16
                  (and (= x "") (= y "")))
)

; ----------------
; escapeString
; -----------------
; https://github.com/google/closure-library/blob/master/closure/goog/string/string.js#L1005

(define-funs-rec ((escapeString ((x String) (y String)) Bool)
                  (es1        ((x String) (y String)) Bool)
                  (es2        ((x String) (y String)) Bool)
                  (es3        ((x String) (y String)) Bool)
                  (es4        ((x String) (y String)) Bool)
                  (es5        ((x String) (y String)) Bool)
                  (es6        ((x String) (y String)) Bool)
                  (es7        ((x String) (y String)) Bool)
                  (es8        ((x String) (y String)) Bool)
                  (es9        ((x String) (y String)) Bool)
                  (es10       ((x String) (y String)) Bool)
                  (es11       ((x String) (y String)) Bool)
                  (es12       ((x String) (y String)) Bool)
                  (es13       ((x String) (y String)) Bool)) (
                  ; definition of escapeString
                  (or (and (bvult (_ bv31 8) (seq-head x))
                           (bvult (seq-head x) (_ bv127 8))
                           (= (seq-head x) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head y) (_ bv92 8))
                           (or (not (bvult (_ bv31 8) (seq-head x)))
                               (not (bvult (seq-head x) (_ bv127 8))))
                           (es1 (seq-tail x) (seq-tail y)))
                      (and (= x "") (= y "")))
                           
                  ; definition of es1
                  (and (= (seq-head y) (_ bv120 8))
                       (bvult (seq-head x) (_ bv256 8))
                       (es2 x (seq-tail y)))
                   
                  ; definition es2
                  (or (and (bvule (_ bv0 8) (seq-head x))
                           (bvule (seq-head x) (_ bv15 8))
                           (= (seq-head y) (_ bv48 8))
                           (es3 x (seq-tail y)))
                      (and (bvule (_ bv16 8) (seq-head x))
                           (bvule (seq-head x) (_ bv31 8))
                           (= (seq-head y) (_ bv49 8))
                           (es4 x (seq-tail y)))
                      (and (= (seq-head x) (_ bv127 8))
                           (= (seq-head y) (_ bv55 8))
                           (es5 (seq-tail x) (seq-tail y)))
                      (and (bvule (_ bv128 8) (seq-head x))
                           (bvule (seq-head x) (_ bv143 8))
                           (= (seq-head y) (_ bv56 8))
                           (es6 x (seq-tail y)))
                      (and (bvule (_ bv144 8) (seq-head x))
                           (bvule (seq-head x) (_ bv159 8))
                           (= (seq-head y) (_ bv57 8))
                           (es7 x (seq-tail y)))
                      (and (bvule (_ bv160 8) (seq-head x))
                           (bvule (seq-head x) (_ bv175 8))
                           (= (seq-head y) (_ bv65 8))
                           (es8 x (seq-tail y)))
                      (and (bvule (_ bv176 8) (seq-head x))
                           (bvule (seq-head x) (_ bv191 8))
                           (= (seq-head y) (_ bv66 8))
                           (es9 x (seq-tail y)))
                      (and (bvule (_ bv192 8) (seq-head x))
                           (bvule (seq-head x) (_ bv207 8))
                           (= (seq-head y) (_ bv67 8))
                           (es10 x (seq-tail y)))
                      (and (bvule (_ bv208 8) (seq-head x))
                           (bvule (seq-head x) (_ bv223 8))
                           (= (seq-head y) (_ bv68 8))
                           (es11 x (seq-tail y)))
                      (and (bvule (_ bv224 8) (seq-head x))
                           (bvule (seq-head x) (_ bv239 8))
                           (= (seq-head y) (_ bv69 8))
                           (es12 x (seq-tail y)))
                      (and (bvule (_ bv240 8) (seq-head x))
                           (bvule (seq-head x) (_ bv255 8))
                           (= (seq-head y) (_ bv70 8))
                           (es13 x (seq-tail y))))
                           
                  ; definition of es3 0-15 to hex
                  (or (and (bvule (_ bv0 8) (seq-head x))
                           (bvule (seq-head x) (_ bv9 8))
                           (= (seq-head x) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv10 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv11 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv12 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv13 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv14 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv15 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es4 16-31 to hex
                  (or (and (bvule (_ bv16 8) (seq-head x))
                           (bvule (seq-head x) (_ bv25 8))
                           (= (bvsub (seq-head x) (_ bv16 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv26 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv27 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv28 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv29 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv30 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv31 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                  
                  ; definition of es5 12 to hex
                  (and (= (seq-head y) (_ bv70 8))
                       (escapeString x (seq-tail y)))
                       
                  ; definition of es6 128-143 to hex
                  (or (and (bvule (_ bv128 8) (seq-head x))
                           (bvule (seq-head x) (_ bv137 8))
                           (= (bvsub (seq-head x) (_ bv128 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv138 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv139 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv140 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv141 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv142 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv143 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es7 144-159 to hex
                  (or (and (bvule (_ bv144 8) (seq-head x))
                           (bvule (seq-head x) (_ bv153 8))
                           (= (bvsub (seq-head x) (_ bv144 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv154 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv155 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv156 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv157 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv158 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv159 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es8 160-175 to hex
                  (or (and (bvule (_ bv160 8) (seq-head x))
                           (bvule (seq-head x) (_ bv169 8))
                           (= (bvsub (seq-head x) (_ bv160 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv170 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv171 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv172 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv173 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv174 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv175 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es9 176-191 to hex
                  (or (and (bvule (_ bv176 8) (seq-head x))
                           (bvule (seq-head x) (_ bv185 8))
                           (= (bvsub (seq-head x) (_ bv176 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv186 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv187 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv188 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv189 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv190 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv191 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es10 192-207 to hex
                  (or (and (bvule (_ bv192 8) (seq-head x))
                           (bvule (seq-head x) (_ bv201 8))
                           (= (bvsub (seq-head x) (_ bv192 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv202 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv203 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv204 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv205 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv206 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv207 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                  
                  ; definition of es11 208-223 to hex
                  (or (and (bvule (_ bv208 8) (seq-head x))
                           (bvule (seq-head x) (_ bv217 8))
                           (= (bvsub (seq-head x) (_ bv208 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv218 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv219 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv220 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv221 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv222 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv223 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es12 224-239 to hex
                  (or (and (bvule (_ bv224 8) (seq-head x))
                           (bvule (seq-head x) (_ bv233 8))
                           (= (bvsub (seq-head x) (_ bv224 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv234 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv235 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv236 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv237 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv238 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv239 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                           
                  ; definition of es13 240-255 to hex
                  (or (and (bvule (_ bv240 8) (seq-head x))
                           (bvule (seq-head x) (_ bv249 8))
                           (= (bvsub (seq-head x) (_ bv240 8)) (seq-head y))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv250 8))
                           (= (seq-head y) (_ bv65 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv251 8))
                           (= (seq-head y) (_ bv66 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv252 8))
                           (= (seq-head y) (_ bv67 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv253 8))
                           (= (seq-head y) (_ bv68 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv254 8))
                           (= (seq-head y) (_ bv69 8))
                           (escapeString (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv255 8))
                           (= (seq-head y) (_ bv70 8))
                           (escapeString (seq-tail x) (seq-tail y))))
                  )
)

(declare-fun x   () String)
(declare-fun y   () String)
(declare-fun z   () String)
(declare-fun w1  () String)
(declare-fun w2  () String)
(declare-fun w3  () String)
(declare-fun e1  () String)
(declare-fun cat () String)

; <button onclick="createCatList(\'' + y + '\')">' + x + '</button>'>; 
(assert (= w1 "<button onclick=\""createCatList('"))
(assert (= w2 "\"")'"))
(assert (= w3 "</button'>"))
;(assert (= cat "Flora & Fauna"))
(assert (= cat "');alert(1);//"))
;(assert (htmlEscape cat x))
;(assert (escapeString x y))
(assert (= z (str.++ (str.++ (str.++ (str.++ w1 y) w2) x) w3)))
(assert (= z (str.++ w1 y w2 x w3)))

; regex /<button onclick="createList\('   ('|[^']*[^'\\]') \); [^']*[^'\\] ')">   .*   <\/button>/
(assert (str.in.re z (re.++ (str.to.re "<button onclick=\""createList('") (re.union (re.range #b00100111 #b00100111) (re.++ (re.* (re.union (re.range #b00000000 #b00100110) (re.range #b00101000 #b11111111))) (re.++ (re.union (re.union (re.range #b00000000 #b00100110) (re.range #b00101000 #b01011011)) (re.range #b01011101 #b11111111)) (re.range #b00100111 #b00100111)))) (str.to.re ");") (re.* (re.union (re.range #b00000000 #b00100110) (re.range #b00101000 #b11111111))) (re.union (re.union (re.range #b00000000 #b00100110) (re.range #b00101000 #b01011011)) (re.range #b01011101 #b11111111)) (str.to.re "')\"">") (re.* re.allchar) (str.to.re "</button>"))))

(check-sat)
