(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /file=[\u{7c}\u{27}]/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/file=") (re.union (str.to_re "|") (str.to_re "'")) (str.to_re "/Ui\u{0a}")))))
; /&q=[a-f0-9]{32},[a-f0-9]{16}&kgs=/U
(assert (not (str.in_re X (re.++ (str.to_re "/&q=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&kgs=/U\u{0a}")))))
; LOGLiveHost\x3ALOGHandyhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "LOGLiveHost:LOGHandyhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; ^\d*\.?(((5)|(0)|))?$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.union (str.to_re "5") (str.to_re "0"))) (str.to_re "\u{0a}")))))
; /^[A-Z0-9._-]+@[A-Z0-9.-]+\.[A-Z0-9.-]+$/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
