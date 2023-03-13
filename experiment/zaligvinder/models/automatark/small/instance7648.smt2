(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /&key=[a-z0-9]{32}&dummy=\d{3,5}/Ui
(assert (str.in_re X (re.++ (str.to_re "/&key=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&dummy=") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; /\u{2f}[a-z0-9]+\.php\?php\u{3d}receipt$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".php?php=receipt/Ui\u{0a}"))))
; /filename=[^\n]*\u{2e}zip/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}"))))
; ^.{2,}$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) re.allchar) (re.* re.allchar))))
; ^\\([^\\]+\\)*[^\/:*?"<>|]?$
(assert (str.in_re X (re.++ (str.to_re "\u{5c}") (re.* (re.++ (re.+ (re.comp (str.to_re "\u{5c}"))) (str.to_re "\u{5c}"))) (re.opt (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re "\u{0a}"))))
(check-sat)
