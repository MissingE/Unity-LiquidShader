using UnityEditor;
using UnityEngine;

public class Missing_LiquidShader_CustomEditor : ShaderGUI
{
    private static bool mainSettingsOpen = true;
    private static bool lineSettingsOpen = true;
    private static bool renderSettingsOpen = true;
    private static bool isKorean = true;

    private void DrawLanguageSwitchButtons()
    {
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("한글"))
        {
            isKorean = true;
        }
        if (GUILayout.Button("English"))
        {
            isKorean = false;
        }
        GUILayout.EndHorizontal();
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        DrawLanguageSwitchButtons();

        GUIStyle Header = new GUIStyle(EditorStyles.foldout);
        Header.fontStyle = FontStyle.Bold;

        // 메인 설정
        mainSettingsOpen = EditorGUILayout.Foldout(mainSettingsOpen, isKorean ? "메인 설정" : "Main Settings", true, Header);
        if (mainSettingsOpen)
        {
            materialEditor.ColorProperty(FindProperty("_Colour", properties), isKorean ? "메인 색상" : "Main Color");
            materialEditor.ColorProperty(FindProperty("_TopColor", properties), isKorean ? "상단 색상" : "Top Color");
            materialEditor.RangeProperty(FindProperty("_Fill", properties), isKorean ? "채우기" : "Fill");
        }

        // 라인 설정
        lineSettingsOpen = EditorGUILayout.Foldout(lineSettingsOpen, isKorean ? "라인 설정" : "Line Settings", true, Header);
        if (lineSettingsOpen)
        {
            materialEditor.ColorProperty(FindProperty("_LineColor", properties), isKorean ? "선 색상" : "Line Color");
            materialEditor.RangeProperty(FindProperty("_LineWidth", properties), isKorean ? "선 길이" : "Line Width");
        }

        // 렌더 설정
        renderSettingsOpen = EditorGUILayout.Foldout(renderSettingsOpen, isKorean ? "렌더 설정" : "Render Settings", true, Header);
        if (renderSettingsOpen)
        {
            MaterialProperty cullModeProperty = FindProperty("_CullMode", properties);
            if (cullModeProperty != null)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.PrefixLabel(isKorean ? "컬 모드" : "Cull Mode");

                string[] cullModes = new string[] { "Off", "Front", "Back" };
                cullModeProperty.floatValue = GUILayout.Toolbar((int)cullModeProperty.floatValue, cullModes);

                EditorGUILayout.EndHorizontal();
            }
        }
    }
}
