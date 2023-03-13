(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\/[0-9]$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/Ui\u{0a}")))))
; dialupvpn\u{5f}pwd\x2Fiis2ebs\.aspOn-Line\x2E\x2E\x2EReport\x2Fnewsurfer4\x2FURLAuthorization\u{3a}
(assert (not (str.in_re X (str.to_re "dialupvpn_pwd/iis2ebs.aspOn-Line...Report/newsurfer4/URLAuthorization:\u{0a}"))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}")))
; are\s+Toolbar\s+X-Mailer\x3AInformationsearchnuggetspastb\x2Efreeprod\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}Informationsearchnugget\u{13}spastb.freeprod.com\u{0a}")))))
(check-sat)
