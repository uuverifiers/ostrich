(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\([2-9]|[2-9])(\d{2}|\d{2}\))(-|.|\s)?\d{3}(-|.|\s)?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.range "2" "9")) (re.range "2" "9")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")"))) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([A-Z]{2}|[A-Z]\d|\d[A-Z])[1-9](\d{1,3})?$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.range "1" "9") (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; horoscope2YAHOOwww\u{2e}2-seek\u{2e}com\u{2f}searchHost\x3A
(assert (str.in_re X (str.to_re "horoscope2YAHOOwww.2-seek.com/searchHost:\u{0a}")))
; Host\u{3a}YOUR\x2Fxml\x2Ftoolbar\x2FGREATExplorerSecureNet
(assert (not (str.in_re X (str.to_re "Host:YOUR/xml/toolbar/GREATExplorerSecureNet\u{0a}"))))
; [\s0-9a-zA-Z\;\"\,\<\>\\?\+\=\)\(\\*\&\%\\$\#\.]*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re ";") (str.to_re "\u{22}") (str.to_re ",") (str.to_re "<") (str.to_re ">") (str.to_re "\u{5c}") (str.to_re "?") (str.to_re "+") (str.to_re "=") (str.to_re ")") (str.to_re "(") (str.to_re "*") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
