(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar.*www\x2Ewebcruiser\x2Ecc\w+www\x2Etopadwarereviews\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* re.allchar) (str.to_re "www.webcruiser.cc") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}"))))
; ^(0|\+33)[1-9]([-. ]?[0-9]{2}){4}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (str.to_re "+33")) (re.range "1" "9") ((_ re.loop 4 4) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Information\s+Host\x3A.*com
(assert (not (str.in_re X (re.++ (str.to_re "Information") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "com\u{0a}")))))
; /\.getElements?By(Id|TagName)\u{28}\s*[\u{22}\u{27}]caption[\u{22}\u{27}]\s*\u{29}.*?innerHTML\s*\u{3d}\s*[\u{22}\u{27}]\u{3c}thead/sm
(assert (str.in_re X (re.++ (str.to_re "/.getElement") (re.opt (str.to_re "s")) (str.to_re "By") (re.union (str.to_re "Id") (str.to_re "TagName")) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "caption") (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") (re.* re.allchar) (str.to_re "innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "<thead/sm\u{0a}"))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
