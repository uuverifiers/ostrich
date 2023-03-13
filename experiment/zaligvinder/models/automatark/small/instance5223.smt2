(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0{1})?([0-3]{0,1}))(\.[0-9]{0,2})?$|^(4)(\.[0]{1,2})?$|^((0{1})?([0-4]{0,1}))(\.)?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "3"))) (re.++ (str.to_re "4") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ (re.opt (str.to_re ".")) (str.to_re "\u{0a}") (re.opt ((_ re.loop 1 1) (str.to_re "0"))) (re.opt (re.range "0" "4")))))))
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}"))))
; \.exe\s+v2\x2E0\s+smrtshpr-cs-
(assert (not (str.in_re X (re.++ (str.to_re ".exe") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "v2.0") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "smrtshpr-cs-\u{13}\u{0a}")))))
; wowokayoffers\x2Ebullseye-network\x2EcomRTB\x0D\x0A\x0D\x0AAttached
(assert (not (str.in_re X (str.to_re "wowokayoffers.bullseye-network.comRTB\u{0d}\u{0a}\u{0d}\u{0a}Attached\u{0a}"))))
(check-sat)
