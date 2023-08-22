(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Kontiki\s+resultsmaster\x2Ecom\u{7c}roogoo\u{7c}
(assert (str.in_re X (re.++ (str.to_re "Kontiki") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}|roogoo|\u{0a}"))))
; /\/ZES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (not (str.in_re X (re.++ (str.to_re "//ZES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}")))))
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}"))))
; Host\u{3a}\w+Pre.*Keyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.* re.allchar) (str.to_re "Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}"))))
; /(<\/?)(\w+)([^>]*>)/e
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/e\u{0a}<") (re.opt (str.to_re "/")) (re.* (re.comp (str.to_re ">"))) (str.to_re ">"))))
(assert (> (str.len X) 10))
(check-sat)
