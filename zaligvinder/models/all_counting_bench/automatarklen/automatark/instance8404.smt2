(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; search\.dropspam\.com.*pjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (re.++ (str.to_re "search.dropspam.com") (re.* re.allchar) (str.to_re "pjpoptwql/rlnj\u{0a}")))))
; /filename=[^\n]*\u{2e}pfm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfm/i\u{0a}"))))
; ^[+][0-9]\d{2}-\d{3}-\d{4}$
(assert (str.in_re X (re.++ (str.to_re "+") (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\u{3a}YOUR\x2Fxml\x2Ftoolbar\x2FGREATExplorerSecureNet
(assert (not (str.in_re X (str.to_re "Host:YOUR/xml/toolbar/GREATExplorerSecureNet\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
