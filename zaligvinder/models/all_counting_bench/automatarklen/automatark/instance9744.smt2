(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+7")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " "))))) ((_ re.loop 7 10) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " "))) (str.to_re "\u{0a}")))))
; Black\s+Warezxmlns\x3A%3flinkautomatici\x2EcomSubject\u{3a}Host\x3A
(assert (str.in_re X (re.++ (str.to_re "Black") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Warezxmlns:%3flinkautomatici.comSubject:Host:\u{0a}"))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
; actualnames\.comclient\x2Ebaigoo\x2Ecomzzzvmkituktgr\u{2f}etiexpsp2-InformationHost\x3A
(assert (not (str.in_re X (str.to_re "actualnames.comclient.baigoo.comzzzvmkituktgr/etiexpsp2-InformationHost:\u{0a}"))))
; /\/cache\/pdf\x5Fefax\x5F\d{8,15}\.zip$/Ui
(assert (str.in_re X (re.++ (str.to_re "//cache/pdf_efax_") ((_ re.loop 8 15) (re.range "0" "9")) (str.to_re ".zip/Ui\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
