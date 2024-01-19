(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((\.\.){1}/)*|(/){1})?(([a-zA-Z0-9]*)/)*([a-zA-Z0-9]*)+([.jpg]|[.gif])+$
(assert (str.in_re X (re.++ (re.opt (re.union (re.* (re.++ ((_ re.loop 1 1) (str.to_re "..")) (str.to_re "/"))) ((_ re.loop 1 1) (str.to_re "/")))) (re.* (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/"))) (re.+ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.+ (re.union (str.to_re ".") (str.to_re "j") (str.to_re "p") (str.to_re "g") (str.to_re "i") (str.to_re "f"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}fon/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fon/i\u{0a}"))))
; TSA\x2FS\u{3a}Users\u{5c}http\x3A\x2F\x2Ftv\x2Eseekmo\x2Ecom\x2Fshowme\x2Easpx\x3Fkeyword=
(assert (str.in_re X (str.to_re "TSA/S:Users\u{5c}http://tv.seekmo.com/showme.aspx?keyword=\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
