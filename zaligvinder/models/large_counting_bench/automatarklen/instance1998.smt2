(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+community\d+
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "community") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; OS-www\x2Etopadwarereviews\x2Ecommedia\x2Etop-banners\x2EcomSuccessfully\u{21}
(assert (str.in_re X (str.to_re "OS-www.topadwarereviews.commedia.top-banners.comSuccessfully!\u{0a}")))
; ^([1-zA-Z0-1@.\s]{1,255})$
(assert (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "1" "z") (re.range "A" "Z") (re.range "0" "1") (str.to_re "@") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; (.*)-----(BEGIN|END)([^-]*)-----(.*)
(assert (not (str.in_re X (re.++ (re.* re.allchar) (str.to_re "-----") (re.union (str.to_re "BEGIN") (str.to_re "END")) (re.* (re.comp (str.to_re "-"))) (str.to_re "-----") (re.* re.allchar) (str.to_re "\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
