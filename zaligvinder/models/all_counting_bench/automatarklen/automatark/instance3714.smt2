(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TM_SEARCH3Host\u{3a}User-Agent\x3Amedia\x2Edxcdirect\x2Ecom
(assert (str.in_re X (str.to_re "TM_SEARCH3Host:User-Agent:media.dxcdirect.com\u{0a}")))
; (^3[47])((\d{11}$)|(\d{13}$))
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))) (str.to_re "\u{0a}3") (re.union (str.to_re "4") (str.to_re "7"))))))
; ^\s*
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^((\d{1,2})?([.][\d]{1,2})?){1}[%]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt ((_ re.loop 1 2) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) ((_ re.loop 1 1) (str.to_re "%")) (str.to_re "\u{0a}"))))
; \x2Fezsb\s+hirmvtg\u{2f}ggqh\.kqh\dRemotetoolsbar\x2Ekuaiso\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "/ezsb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.range "0" "9") (str.to_re "Remotetoolsbar.kuaiso.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
