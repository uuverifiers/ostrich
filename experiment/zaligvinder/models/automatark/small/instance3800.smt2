(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; dat\s+resultsmaster\x2Ecom.*Host\u{3a}.*SpyAgentRootHost\x3AAdToolsSubject\x3Ae2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "dat") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "SpyAgentRootHost:AdToolsSubject:e2give.com\u{0a}")))))
; /filename=[^\n]*\u{2e}vwr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vwr/i\u{0a}")))))
; ^[+]447\d{9}$
(assert (not (str.in_re X (re.++ (str.to_re "+447") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
