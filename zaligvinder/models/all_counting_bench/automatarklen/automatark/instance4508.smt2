(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\s+e2give\.com\s+NETObservemedia\x2Edxcdirect\x2EcomSubject\x3Aquick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObservemedia.dxcdirect.comSubject:quick.qsrch.com\u{0a}")))))
; [:;]{1}[-~+o]?[(<\[]+
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re ":") (str.to_re ";"))) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re "(") (str.to_re "<") (str.to_re "["))) (str.to_re "\u{0a}"))))
; ^[^\s]+@[^\.][^\s]{1,}\.[A-Za-z]{2,10}$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "@") (re.comp (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".") ((_ re.loop 2 10) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; User-Agent\x3AX-Mailer\u{3a}HWAEHost\x3AHost\x3AHost\u{3a}StableUser-Agent\x3AUser-Agent\x3Awww\u{2e}navisearch\u{2e}net
(assert (str.in_re X (str.to_re "User-Agent:X-Mailer:\u{13}HWAEHost:Host:Host:StableUser-Agent:User-Agent:www.navisearch.net\u{0a}")))
; /nsrmm[^\u{00}]*?([\u{3b}\u{7c}\u{26}\u{60}]|\u{24}\u{28})/
(assert (str.in_re X (re.++ (str.to_re "/nsrmm") (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "$(") (str.to_re ";") (str.to_re "|") (str.to_re "&") (str.to_re "`")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
