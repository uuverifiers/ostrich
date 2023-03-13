(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AHost\x3AhasHost\x3AComputerKeylogger\x2Ecom
(assert (not (str.in_re X (str.to_re "User-Agent:Host:hasHost:ComputerKeylogger.com\u{0a}"))))
; ^\d{5}-\d{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; X-Mailer\u{3a}+Host\x3A\x2EaspxHost\x3Av=User-Agent\u{3a}xbqyosoe\u{2f}cpvmRequestwww\x2Ealtnet\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "X-Mailer") (re.+ (str.to_re ":")) (str.to_re "Host:.aspxHost:v=User-Agent:xbqyosoe/cpvmRequestwww.altnet.com\u{1b}\u{0a}")))))
; \S*?[\["].*?[\]"]|\S+
(assert (str.in_re X (re.union (re.++ (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (str.to_re "[") (str.to_re "\u{22}")) (re.* re.allchar) (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
; NETObserveSupervisorHost\x3Awebsearch\x2Edrsnsrch\x2Ecom
(assert (not (str.in_re X (str.to_re "NETObserveSupervisorHost:websearch.drsnsrch.com\u{13}\u{0a}"))))
(check-sat)
