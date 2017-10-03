(set-logic QF_S)

; ----------------
; EscapeString by Dunkey
; -----------------
; & = &amp;
; < = &lt;
; > = &gt;
; " = &quot;
; ' = &#39;

(define-funs-rec ((escapeString  ((x String) (y String)) Bool)
                  (es1  ((x String) (y String)) Bool)
                  (es2  ((x String) (y String)) Bool)
                  (es3  ((x String) (y String)) Bool)
                  (es4  ((x String) (y String)) Bool)
                  (es5  ((x String) (y String)) Bool)
                  (es6  ((x String) (y String)) Bool)
                  (es7  ((x String) (y String)) Bool)
                  (es8  ((x String) (y String)) Bool)
                  (es9  ((x String) (y String)) Bool)
                  (es10 ((x String) (y String)) Bool)
                  (es11 ((x String) (y String)) Bool)
                  (es12 ((x String) (y String)) Bool)
                  (es13 ((x String) (y String)) Bool)
                  (es14 ((x String) (y String)) Bool)
) (

                  ; definition of escapeString
                  (or (and (= (seq-head x) (_ bv38 8)) ; '&'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (es1 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv60 8)) ; '<'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (es2 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv62 8)) ; '>'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (es3 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv34 8)) ; '\"'
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (es4 (seq-tail x) (seq-tail y)))
                      (and (= (seq-head x) (_ bv39 8)) ; '\''
                           (= (seq-head y) (_ bv38 8)) ; '&'
                           (es5 (seq-tail x) (seq-tail y)))
					       (and (= (seq-head x) (seq-head y))
                           (not (= (seq-head x) (_ bv39 8))) ; '\''
                           (not (= (seq-head x) (_ bv38 8))) ; '&'
                           (not (= (seq-head x) (_ bv60 8))) ; '<'
                           (not (= (seq-head x) (_ bv62 8))) ; '>'
                           (not (= (seq-head x) (_ bv34 8))) ; '\"'
                           (not (= (seq-head x) (_ bv39 8))) ; '\''
                           (escapeString (seq-tail x) (seq-tail y))))

                  ; definition of es1
                  (or (and (= (seq-head y) (_ bv97 8)) ; 'a'
                           (es6 x (seq-tail y))))

                  ; definition of es2
                  (or (and (= (seq-head y) (_ bv108 8)) ; 'l'
                           (es12 x (seq-tail y))))

                  ; definition of es3
                  (or (and (= (seq-head y) (_ bv103 8)) ; 'g'
                           (es12 x (seq-tail y))))

                  ; definition of es4
                  (or (and (= (seq-head y) (_ bv113 8)) ; 'q'
                           (es7 x (seq-tail y))))

                  ; definition of es5
                  (or (and (= (seq-head y) (_ bv35 8)) ; '#'
                           (es8 x (seq-tail y))))

                  ; definition of es6
                  (or (and (= (seq-head y) (_ bv109 8)) ; 'm'
                           (es9 x (seq-tail y))))

                  ; definition of es7
                  (or (and (= (seq-head y) (_ bv117 8)) ; 'u'
                           (es10 x (seq-tail y))))

                  ; definition of es8
                  (or (and (= (seq-head y) (_ bv51 8)) ; '3'
                           (es11 x (seq-tail y))))

                  ; definition of es9
                  (or (and (= (seq-head y) (_ bv112 8)) ; 'p'
                           (es13 x (seq-tail y))))

                  ; definition of es10
                  (or (and (= (seq-head y) (_ bv111 8)) ; 'o'
                           (es12 x (seq-tail y))))

                  ; definition of es11
                  (or (and (= (seq-head y) (_ bv57 8)) ; '9'
                           (es13 x (seq-tail y))))

                  ; definition of es12
                  (or (and (= (seq-head y) (_ bv116 8)) ; 't'
                           (es13 x (seq-tail y))))

                  ; definition of es13
                  (or (and (= (seq-head y) (_ bv59 8)) ; ';'
                           (es14 x (seq-tail y))))

                  ; definition of es14
                  (and (= x "") (= y ""))
))

(declare-fun x () String)
(declare-fun y () String)

(assert (str.in.re x (re.+ (re.union (re.union (re.union (str.to.re "&") (str.to.re "\\'")) (str.to.re "<")) (str.to.re ">")))))
;(assert (escapeString x y))

(check-sat)
