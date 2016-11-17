
namespace DBLab.Database.Domain
{
    public class Document: BaseEntity
    {
        public string FileName { get; set; }
        public string FileType { get; set; }
        public byte[] Content { get; set; }
    }
}
