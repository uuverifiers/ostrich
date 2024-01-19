(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar\w+www\x2Etopadwarereviews\x2Ecommedia\x2Etop-banners\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.commedia.top-banners.com\u{0a}")))))
; ^\d{1,3}((\.\d{1,3}){3}|(\.\d{1,3}){5})$
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union ((_ re.loop 3 3) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) ((_ re.loop 5 5) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}asx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
