(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}csv/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".csv/i\u{0a}")))))
; /bincode=Wz[0-9A-Za-z\u{2b}\u{2f}]{32}\u{3d}{0,2}$/Um
(assert (str.in_re X (re.++ (str.to_re "/bincode=Wz") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "=")) (str.to_re "/Um\u{0a}"))))
; /filename=[^\n]*\u{2e}doc/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".doc/i\u{0a}")))))
; ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G") (str.to_re "v") (str.to_re "e") (str.to_re "j") (str.to_re "g")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /insertBefore\(document\.body\)([^?]+createElement\([\u{22}\u{27}]TR[\u{22}\u{27}]\)\))+[^?]+<body[^?]+?<\/body>/i
(assert (not (str.in_re X (re.++ (str.to_re "/insertBefore(document.body)") (re.+ (re.++ (re.+ (re.comp (str.to_re "?"))) (str.to_re "createElement(") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "TR") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "))"))) (re.+ (re.comp (str.to_re "?"))) (str.to_re "<body") (re.+ (re.comp (str.to_re "?"))) (str.to_re "</body>/i\u{0a}")))))
(check-sat)
