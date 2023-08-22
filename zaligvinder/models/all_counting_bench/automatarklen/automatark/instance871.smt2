(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ATL\w+SoftActivitypassword\x3B0\x3BIncorrect
(assert (not (str.in_re X (re.++ (str.to_re "ATL") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "SoftActivity\u{13}password;0;Incorrect\u{0a}")))))
; LOGLiveHost\x3ALOGHandyhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "LOGLiveHost:LOGHandyhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
