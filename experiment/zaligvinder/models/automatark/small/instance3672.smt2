(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; st=\s+www\.iggsey\.com.*BackAtTaCkadserver\.warezclient\.com
(assert (not (str.in_re X (re.++ (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.com") (re.* re.allchar) (str.to_re "BackAtTaCkadserver.warezclient.com\u{0a}")))))
; /filename=[\u{22}\u{27}]?[^\n]*\u{2e}wpd[\u{22}\u{27}\s]/si
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wpd") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/si\u{0a}"))))
; /\u{2f}panda\u{2f}\u{3f}u\u{3d}[a-z0-9]{32}/U
(assert (not (str.in_re X (re.++ (str.to_re "//panda/?u=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(check-sat)
