(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <!\[CDATA\[([^\]]*)\]\]>
(assert (str.in_re X (re.++ (str.to_re "<![CDATA[") (re.* (re.comp (str.to_re "]"))) (str.to_re "]]>\u{0a}"))))
; Word\w+My\s+\u{22}TheZC-BridgeUser-Agent\x3AserverUSER-Attached
(assert (not (str.in_re X (re.++ (str.to_re "Word") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "My") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}TheZC-BridgeUser-Agent:serverUSER-Attached\u{0a}")))))
; User-Agent\u{3a}User-Agent\x3AReport\x2EHost\x3Afhfksjzsfu\u{2f}ahm\.uqs
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:Report.Host:fhfksjzsfu/ahm.uqs\u{0a}"))))
; ^\d{5}((\-|\s)?\d{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; GREATHost\u{3a}FILESIZE\x3E\x2Fiis2ebs\.aspFTPUser-Agent\x3A
(assert (str.in_re X (str.to_re "GREATHost:FILESIZE>\u{13}/iis2ebs.aspFTPUser-Agent:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
