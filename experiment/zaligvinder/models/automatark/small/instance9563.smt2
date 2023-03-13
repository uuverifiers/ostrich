(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\d+wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}")))))
; TPSystemHost\x3AHost\u{3a}show\x2Eroogoo\x2EcomX-Mailer\x3A
(assert (str.in_re X (str.to_re "TPSystemHost:Host:show.roogoo.comX-Mailer:\u{13}\u{0a}")))
; ^[A-Z]{1}( |-)?[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; PASSW=.*www\x2Emakemesearch\x2Ecom.*HBand,X-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.* re.allchar) (str.to_re "www.makemesearch.com") (re.* re.allchar) (str.to_re "HBand,X-Mailer:\u{13}\u{0a}")))))
(check-sat)
