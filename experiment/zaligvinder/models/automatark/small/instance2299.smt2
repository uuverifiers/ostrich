(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; upgrade\x2Eqsrch\x2Einfo[^\n\r]*dcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dcww.dmcast.com\u{0a}")))))
; fromMinixmlldap\x3A\x2F\x2F\x2Fbonzibuddy\x2Ftoolbar_domain_redirectUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "fromMinixmlldap:///bonzibuddy/toolbar_domain_redirectUser-Agent:\u{0a}"))))
; 62[0-9]{14,17}
(assert (str.in_re X (re.++ (str.to_re "62") ((_ re.loop 14 17) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; dialup\u{5f}vpn\u{40}hermangroup\x2Eorg\s+www\x2Epeer2mail\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "dialup_vpn@hermangroup.org") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.com\u{0a}"))))
; \S*?[\["].*?[\]"]|\S+
(assert (not (str.in_re X (re.union (re.++ (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (str.to_re "[") (str.to_re "\u{22}")) (re.* re.allchar) (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}"))))))
(check-sat)
