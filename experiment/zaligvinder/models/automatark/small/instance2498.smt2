(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; My\x2Fdesktop\x2FWinSessionHost\u{3a}OnlineTPSystem\x7D\x7C
(assert (not (str.in_re X (str.to_re "My/desktop/WinSessionHost:OnlineTPSystem}|\u{0a}"))))
; \S*?[\["].*?[\]"]|\S+
(assert (str.in_re X (re.union (re.++ (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (str.to_re "[") (str.to_re "\u{22}")) (re.* re.allchar) (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
; traffbest\x2Ebiz\d+\.compress.*sidebar\.activeshopper\.comaresflashdownloader\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "traffbest.biz") (re.+ (re.range "0" "9")) (str.to_re ".compress") (re.* re.allchar) (str.to_re "sidebar.activeshopper.comaresflashdownloader.com\u{0a}"))))
; (0?[1-9]|[12][0-9]|3[01])[.](0?[1-9]|1[012])[.]\d{4}
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
