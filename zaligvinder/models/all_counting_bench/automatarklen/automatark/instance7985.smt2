(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+UI2.*areprotocolhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "UI2") (re.* re.allchar) (str.to_re "areprotocolhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; ^([A-Z]{2}[\s]|[A-Z]{2})[\w]{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "A" "Z"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^[^\s]+@[^\.][^\s]{1,}\.[A-Za-z]{2,10}$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "@") (re.comp (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; v=c=DALOGbacktrust\x2EcomHost\x3AConnectedHost\x3AHost\u{3a}Host\u{3a}lsSpyDawn
(assert (str.in_re X (str.to_re "v=c=DALOGbacktrust.comHost:ConnectedHost:Host:Host:lsSpyDawn\u{0a}")))
; \u{23}\u{23}\u{23}\u{23}Host\x3ASubject\x3Awww\x2Epcsentinelsoftware\x2EcomHost\x3AWeHost\u{3a}www\x2Ewowokay\x2Ecom/wowokaybar\x2Ephp
(assert (not (str.in_re X (str.to_re "####Host:Subject:www.pcsentinelsoftware.comHost:WeHost:www.wowokay.com/wowokaybar.php\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
