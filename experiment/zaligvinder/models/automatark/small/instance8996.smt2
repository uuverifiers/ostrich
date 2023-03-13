(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <(.*?)>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* re.allchar) (str.to_re ">\u{0a}"))))
; ^[0-9]{6}
(assert (not (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ((\d{1,5})*\.*(\d{0,3})"[W|D|H|DIA][X|\s]).*
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}") (re.* ((_ re.loop 1 5) (re.range "0" "9"))) (re.* (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re "\u{22}") (re.union (str.to_re "W") (str.to_re "|") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "A")) (re.union (str.to_re "X") (str.to_re "|") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))
; Keystrokes.*LOG.*Host\x3Awww\x2Eserverlogic3\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Keystrokes") (re.* re.allchar) (str.to_re "LOG") (re.* re.allchar) (str.to_re "Host:www.serverlogic3.com\u{0a}")))))
; /\u{2e}p2g([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.p2g") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
