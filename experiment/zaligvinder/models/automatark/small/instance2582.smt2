(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^<>&~\s^%A-Za-z\\][^A-Za-z%^\\<>]{1,25}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "<") (str.to_re ">") (str.to_re "&") (str.to_re "~") (str.to_re "^") (str.to_re "%") (re.range "A" "Z") (re.range "a" "z") (str.to_re "\u{5c}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 25) (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re "%") (str.to_re "^") (str.to_re "\u{5c}") (str.to_re "<") (str.to_re ">"))) (str.to_re "\u{0a}")))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (not (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}"))))
; /filename=[^\n]*\u{2e}f4v/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4v/i\u{0a}")))))
; Host\x3A\d+Host\x3A.*communitytipHost\x3AGirafaClient
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "communitytipHost:GirafaClient\u{13}\u{0a}"))))
(check-sat)
