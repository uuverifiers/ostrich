(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3Alinkautomatici\x2EcomReferer\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "Subject:linkautomatici.comReferer:www.searchreslt.com\u{0a}")))
; /encoding\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (str.in_re X (re.++ (str.to_re "/encoding=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}"))))
; ^\(?[\d]{3}\)?[\s-]?[\d]{3}[\s-]?[\d]{4}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; NSIS_DOWNLOAD.*User-Agent\x3A\s+gpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "NSIS_DOWNLOAD") (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "gpstool.globaladserver.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
