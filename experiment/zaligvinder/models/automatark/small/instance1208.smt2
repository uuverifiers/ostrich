(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}YOUR\x2Fxml\x2Ftoolbar\x2FGREATExplorerSecureNet
(assert (not (str.in_re X (str.to_re "Host:YOUR/xml/toolbar/GREATExplorerSecureNet\u{0a}"))))
; ^(((\+{1})|(0{2}))98|(0{1}))9[1-9]{1}\d{8}\Z$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 2 2) (str.to_re "0"))) (str.to_re "98")) ((_ re.loop 1 1) (str.to_re "0"))) (str.to_re "9") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
