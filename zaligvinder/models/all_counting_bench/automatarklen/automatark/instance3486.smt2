(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (ISBN[-]*(1[03])*[ ]*(: ){0,1})*(([0-9Xx][- ]*){13}|([0-9Xx][- ]*){10})
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "ISBN") (re.* (str.to_re "-")) (re.* (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "3")))) (re.* (str.to_re " ")) (re.opt (str.to_re ": ")))) (re.union ((_ re.loop 13 13) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 10 10) (re.++ (re.union (re.range "0" "9") (str.to_re "X") (str.to_re "x")) (re.* (re.union (str.to_re "-") (str.to_re " ")))))) (str.to_re "\u{0a}"))))
; M\x2Ezip.*w3who.*\x2Fcgi\x2Flogurl\.cgiMyPostdll\x3FHOST\x3A
(assert (not (str.in_re X (re.++ (str.to_re "M.zip") (re.* re.allchar) (str.to_re "w3who") (re.* re.allchar) (str.to_re "/cgi/logurl.cgiMyPostdll?HOST:\u{0a}")))))
; (?s)/\*.*\*/
(assert (str.in_re X (re.++ (str.to_re "/*") (re.* re.allchar) (str.to_re "*/\u{0a}"))))
; /\u{2e}dae([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dae") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
